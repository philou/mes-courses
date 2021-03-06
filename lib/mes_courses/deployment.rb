# Copyright (C) 2011, 2012, 2013, 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


require "uri"
require "net/http"
require 'date'
require 'pty'
require_relative 'deployment/trollop'
require_relative 'utils/timing'
require_relative 'initializers/numeric_extras'

module MesCourses

  module Deployment
    include Utils

    HEROKU_STACK = "cedar"
    TRACE_KEY = "MES_COURSES_DEPLOYMENT_TRACE"
    INTEG = "integ"
    BETA = "beta"

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

    def push(repo, branch = 'master')
      shell "git push #{repo} #{branch}:master"
    end

    def heroku_app(repo)
      "mes-courses-#{repo}"
    end

    def heroku(command, options = {})
      if options.include?(:repo)
        shell "heroku #{command} --app #{heroku_app(options[:repo])}"
      else
        shell "heroku #{command}"
      end
    end

    def migrate(repo)
      heroku "run rake db:migrate #{trace_option}", repo: repo
    end

    def refresh_db(repo)
      raise ArgumentError.new("Cannot refresh the #{BETA} app database") if repo == BETA

      heroku "pg:reset DATABASE --app #{heroku_app(repo)} --confirm #{heroku_app(repo)}"
      heroku "pgbackups:restore DATABASE `heroku pgbackups:url --app #{heroku_app(BETA)}` --app #{heroku_app(repo)} --confirm #{heroku_app(repo)}"
    end

    def deploy(repo, branch = 'master')
      puts "Deploying local branch #{branch} to #{heroku_app(repo)}"
      push repo, branch
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
      puts "\nUnlocking ssh keys"
      shell "ssh-add"

      # puts "\nLaunching deployment to test and integration environments"
      # deployments = start_deploying_test_and_integration_apps

      puts "\nInstalling dependencies"
      bundle "install"

      puts "\nUpdating database"
      bundled_rake "db:migrate:reset", "RAILS_ENV" => "ci"

      puts "\nRunning tests"
      bundled_rake "behaviours", "BEHAVIOURS_ENV" => "ci"

      puts "\nChecking database rollback"
      bundled_rake "db:migrate", "RAILS_ENV" => "ci", "VERSION" => "0"

      puts "\nPushing to main source repository"
      push "main"

      # puts "\nFinishing deployment to test and integration environments"
      # end_deploying_test_and_integration_apps(deployments)

      # puts "\nLaunching stores import in integration environment"
      # launch_stores_import("integ")

      puts "\nIntegration successful :-)"
    end

    def create_heroku_app(repo, pgsql_plan, prod_addons)
      heroku "apps:create --remote #{repo} --stack #{HEROKU_STACK} #{heroku_app(repo)}"

      heroku "addons:add heroku-postgresql:#{pgsql_plan}", repo: repo
      heroku "addons:add scheduler:standard", repo: repo
      heroku "addons:add sendgrid:starter", repo: repo
      heroku "addons:add papertrail:choklad", repo: repo
      heroku "addons:add pgbackups:#{prod_addons ? 'auto-month' : 'plus'}", repo: repo
      heroku "addons:add ssl:endpoint", repo: repo if prod_addons

      heroku "config:set APP_NAME=#{heroku_app(repo)}", repo: repo
      heroku "config:set RACK_ENV=production", repo: repo

      local_env.each do |name, value|
        heroku "config:set #{name}=#{value}", repo: repo
      end
    end

    private

    def precompile_assets
      bundled_rake "assets:precompile", "RAILS_ENV" => "production"
    end

    def trace_option
      if ENV[TRACE_KEY]
        "--trace"
      else
        ""
      end
    end

    MINUTE = 60
    def ping(repo)
      require_relative "../../config/boot"
      require "net/ping"

      url = "https://#{heroku_app(repo)}.herokuapp.com"
      pinger = Net::Ping::HTTP.new(url, nil, 7*MINUTE)
      unless pinger.ping?
        raise RuntimeError.new("The site deployed at \"#{url}\" does not respond to http (warning: #{pinger.warning}, exception: #{pinger.exception})")
      end
    end

    def print_help(name, description)
      puts description
      puts
      puts "  ruby script/#{name}"
      puts
    end

    def notify(summary, status, details)
      image_path = private_file_path("task-#{status}.png")
      shell "notify-send --icon=#{image_path} '#{summary}' '#{details}'"
    end

    def start_deploying_test_and_integration_apps
      start_parallel_exec(test_and_integration_repos.map do |repo|
        [repo, "#{private_ruby_command('do_deploy')} --repo #{repo} #{repo == INTEG ? '--refresh-db' : ''}"]
      end)
    end

    def end_deploying_test_and_integration_apps(deployments)
      deployment_failures = end_parallel_exec(deployments)

      unless deployment_failures.empty?
        raise RuntimeError.new("Deployment to heroku repos [#{deployment_failures.join(", ")}] failed.")
      end
    end

    def launch_stores_import(repo)
      processes = current_stores_imports(repo)
      kill_current_stores_imports(repo, processes)

      limit_to_save_billing(repo, processes) do
        do_launch_stores_import(repo)
      end
    end
    def current_stores_imports(repo)
      `bundle exec heroku ps --app #{heroku_app(repo)} | grep "rake scheduled:stores:import" | sed "s/:.*//"`.split("\n")
    end
    def kill_current_stores_imports(repo, processes)
      processes.each do |process|
        heroku "ps:stop #{process}", repo: repo
      end
    end
    def limit_to_save_billing(repo, processes)
      one_day = 1
      last_import_date_var = "LAST_IMPORT_DATE"

      last_import = get_heroku_time_var(repo, last_import_date_var)

      if !processes.empty? or last_import < DateTime.now - one_day

        set_heroku_time_var(repo, last_import_date_var, DateTime.now)
        yield
      end
    end

    def get_heroku_time_var(repo, var_name)
      result_s = `bundle exec heroku config --app #{heroku_app(repo)} | grep "#{var_name}" | sed "s/^[^:]*: *//"`.strip
      if result_s.empty?
        DateTime.new(0)
      else
        DateTime.parse(result_s)
      end
    end
    def set_heroku_time_var(repo, var_name, dateTime)
      heroku "config:set #{var_name}=\"#{dateTime.iso8601}\"", repo: repo
    end
    def do_launch_stores_import(repo)
      heroku "run:detached rake scheduled:stores:import", repo: repo
    end

    def start_parallel_exec(commands)
      failures = []
      outputs = []
      threads = commands.map do |item, command|
        Thread.new do
          output, status = exec_non_interactive command
          outputs << output
          failures << item unless status == 0
        end
      end
      return lambda do
        threads.each {|thread| thread.join }
        puts outputs.join("\n")
        failures
      end
    end
    def end_parallel_exec(callback)
      callback.call
    end

    def exec_non_interactive(command)
      PTY.spawn command do |r,w,pid|
        all_output_lines = []
        begin
          while (true)
            all_output_lines.push(r.readline)
          end
        rescue Errno::EIO => e
          # reached the end of output
        end
        return [all_output_lines.join, PTY.check(pid)]
      end
    end

    def private_ruby_command(script_name)
      "ruby #{private_file_path(script_name)}.rb"
    end

    def private_file_path(file_name)
      File.join(File.dirname(__FILE__),"deployment",file_name)
    end

    def local_env
      local_env_file = File.join(File.dirname(__FILE__), "../../config/local_env.yml")
      File.open(local_env_file).map do |line|
        /^\s+([^#:][^:]*):([^\n]*)$/.match(line)
      end.find_all do |m|
        !m.nil?
      end.map do |m|
        m.captures.map &:strip
      end
    end
  end
end
