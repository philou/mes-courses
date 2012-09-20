# Copyright (C) 2011, 2012 by Philippe Bourgau

require_relative "../../config/boot"
require "uri"
require "net/http"
require 'trollop'
require_relative 'utils/timing'
require_relative 'initializers/numeric_extras'

module MesCourses

  module Deployment
    include Utils

    HEROKU_STACK = "bamboo-ree-1.9.2"
    TRACE_KEY = "MES_COURSES_DEPLOYMENT_TRACE"

    def shell(command, env = {})
      pid = Process.spawn(env, command)
      _,status = Process.wait2(pid)
      unless status == 0
        raise RuntimeError.new("Command \"#{command}\" failed with status #{status}.")
      end
    end

    def bundle(subcommand, env ={})
      shell "bundle #{subcommand}", env
    end

    def bundle_exec(subcommand, env = {})
      bundle "exec #{subcommand}", env
    end

    def bundled_rake(task, env = {})
      bundle_exec "rake #{trace_option} #{task}", env
    end

    def pull(repo)
      shell "git pull #{repo} master"
    end

    def push(repo)
      shell "git push #{repo} master"
    end

    def heroku_app(repo)
      "mes-courses-#{repo}"
    end

    def heroku(command, options = {})
      if options.include?(:repo)
        bundle_exec "heroku #{command} --app #{heroku_app(options[:repo])}"
      else
        bundle_exec "heroku #{command}"
      end
    end

    def migrate(repo)
      heroku "run rake db:migrate --trace", repo: repo
    end

    def deploy(repo)
      puts "Deploying to #{heroku_app(repo)}"
      push repo
      migrate repo
      ping repo
    end

    def y_or_n?(text)
      text.strip.downcase == 'y'
    end

    def with_confirmation(task_summary)
      puts "Are you sure you want to #{task_summary} ? (y/n)"
      answer = STDIN.readline
      if y_or_n?(answer)
        begin
          yield
          notify(task_summary, :success, "On the track to success !")
        rescue Exception => e
          notify(task_summary, :failure, "Failure : #{e.message}")
          raise
        end
      end
    end

    def with_timing
      Timing.duration_of do |timer|
        begin
          yield
        ensure
          puts "\nTook #{timer.seconds.to_pretty_duration}"
        end
      end
    end

    def with_trace_argument(description, init_proc = nil)
      options = Trollop::options do
        banner description
        opt :trace, "print detailed backtrace on failure"
        instance_eval &init_proc unless init_proc.nil?
      end

      if options[:trace]
        ENV[TRACE_KEY] ||= "true"
      end

      begin
        yield options
      rescue Exception => e
        STDERR.puts "Error : #{e.message}"
        STDERR.puts "Backtrace :\n\t#{e.backtrace.join("\n\t")}" if ENV[TRACE_KEY]
        exit 1
      end
    end

    def test_and_integration_repos
      ["watchdog", "integ"]
    end

    def integrate
      puts "\nInstalling dependencies"
      bundle "install"

      puts "\nUpdating database"
      bundled_rake "db:migrate", "RAILS_ENV" => "ci"
      bundled_rake "db:migrate", "RAILS_ENV" => "ci", "VERSION" => "0"
      bundled_rake "db:migrate:reset", "RAILS_ENV" => "ci"

      puts "\nRunning tests"
      bundled_rake "behaviours", "BEHAVIOURS_ENV" => "ci"

      puts "\nPushing to main source repository"
      push "main"

      puts "\nDeploying to test and integration environments"
      test_and_integration_repos.each do |repo|
        deploy(repo)
      end

      puts "\nLaunching stores import in integration environment"
      launch_stores_import("integ")

      puts "\nIntegration successful :-)"
    end

    def create_heroku_app(repo, heroku_password)
      heroku "apps:create --remote #{repo} --stack #{HEROKU_STACK} #{heroku_app(repo)}"

      heroku "addons:add cron:daily", repo: repo
      heroku "addons:upgrade logging:expanded", repo: repo
      heroku "addons:add sendgrid:starter", repo: repo

      heroku "config:set HIREFIRE_EMAIL=philippe.bourgau@gmail.com HIREFIRE_PASSWORD=#{heroku_password}", repo: repo
    end

    private

    def trace_option
      if ENV[TRACE_KEY]
        "--trace"
      else
        ""
      end
    end

    def ping(repo)
      url = "http://#{heroku_app(repo)}.heroku.com/dishes"
      response = Net::HTTP.get_response(URI(url))
      unless response.is_a? Net::HTTPSuccess or response.is_a? Net::HTTPRedirection
        raise RuntimeError.new("The site deployed at \"#{url}\" returned an http error (code #{response.code})")
      end
    end

    def print_help(name, description)
      puts description
      puts
      puts "  ruby script/#{name}"
      puts
    end

    def notify(summary, status, details)
      shell "notify-send --icon=#{File.join(File.dirname(__FILE__),"deployment","task-#{status}.png")} '#{summary}' '#{details}'"
    end

    def launch_stores_import(repo)
      processes = current_stores_imports(repo)
      kill_current_stores_imports(processes)

      limit_to_save_billing(repo, processes) do
        do_launch_stores_import(repo)
      end
    end
    def current_stores_imports(repo)
      `bundle exec heroku ps --app #{heroku_app(repo)} | grep "rake scheduled:stores:import" | sed "s/:.*//"`.split("\n")
    end
    def kill_current_stores_imports(processes)
      processes.each do |process|
        heroku "ps:stop #{process}", repo: repo
      end
    end
    def limit_to_save_billing(repo, processes)
      one_week = 7 * 24 * 60 * 60
      last_import_date_var = "LAST_IMPORT_DATE"

      last_import = get_heroku_time_var(repo, last_import_date_var)

      if !processes.empty? or last_import < Time.now - one_week

        set_heroku_time_var(repo, last_import_date_var, Time.now)
        yield
      end
    end

    def get_heroku_time_var(repo, var_name)
      result_s = `bundle exec heroku ps --app #{heroku_app(repo)} | grep "#{var_name}" | sed "s/^[^:]*: *//"`.strip
      if result_s.empty?
        Time.new(0)
      else
        result_s.to_time.getlocal
      end
    end
    def set_heroku_time_var(repo, var_name, time)
      heroku "config:set #{var_name}=#{time.getutc.to_s}", repo: repo
    end
    def do_launch_stores_import(repo)
      heroku "run:detached rake scheduled:stores:import", repo: repo
    end
  end
end
