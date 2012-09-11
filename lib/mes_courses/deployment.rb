# Copyright (C) 2011, 2012 by Philippe Bourgau

require "uri"
require "net/http"
require_relative 'utils/timing'
require_relative 'initializers/numeric_extras'

module MesCourses

  module Deployment
    include Utils

    HEROKU_STACK = "bamboo-ree-1.9.2"

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
      bundle_exec "rake #{task}", env
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
      heroku "run rake db:migrate --trace", :repo => repo
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
          notify(task_summary, :success)
        rescue
          notify(task_summary, :failure)
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

    def with_help_support(name, description)
      if ARGV.count != 0 and ["help", "-h","--help"].include?(ARGV[0])
        print_help(name, description)
      else
        yield
      end
    end

    def with_repo_argument(name, description)
      if ARGV.count == 0 or ["help", "-h","--help"].include?(ARGV[0])
        print_help("#{name} REPO", description)
      else
        yield ARGV[0]
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
      bundled_rake "behaviours", "RAILS_ENV" => "ci"

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

    def create_heroku_app(repo)
      heroku "apps:create --remote #{repo} --stack #{HEROKU_STACK} #{heroku_app(repo)}"

      heroku "addons:add cron:daily", :repo => repo
      heroku "addons:upgrade logging:expanded", :repo => repo
      heroku "addons:add sendgrid:starter", :repo => repo

      heroku "config:add HIREFIRE_EMAIL=philippe.bourgau@gmail.com HIREFIRE_PASSWORD=J\\'ai\\ 2\\ nikes\\ air\\ au\\ cou\\!", :repo => repo
    end

    private

    def ping(repo)
      url = "http://#{heroku_app(repo)}.heroku.com/dishes"
      response = Net::HTTP.get_response(URI(url))
      raise RuntimeError.new("The site deployed at \"#{url}\" returned an http error (code #{response.code})") unless response.is_a? Net::HTTPSuccess
    end

    def print_help(name, description)
      puts description
      puts
      puts "  ruby script/#{name}"
      puts
    end

    def notify(summary, status)
      shell "notify-send --icon=#{File.join(File.dirname(__FILE__),"deployment","task-#{status}.png")} 'mes-courses' '#{summary} #{status}'"
    end

    def launch_stores_import(repo)
      kill_current_stores_imports(repo)
      do_launch_stores_import(repo)
    end
    def kill_current_stores_imports(repo)
      current_stores_imports(repo).each do |process|
        heroku "ps:stop #{process}", :repo => repo
      end
    end
    def current_stores_imports(repo)
      `heroku ps --app #{heroku_app(repo)} | grep "rake scheduled:stores:import" | sed "s/:.*//"`.split("\n")
    end
    def do_launch_stores_import(repo)
      heroku "run:detached rake scheduled:stores:import", :repo => repo
    end
  end
end
