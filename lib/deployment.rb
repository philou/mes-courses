# Copyright (C) 2011, 2012 by Philippe Bourgau

require_relative 'time_span_helper'

module Deployment

  HEROKU_STACK = "bamboo-ree-1.9.2"

  def shell(command)
    unless system command
      raise RuntimeError.new("Command \"#{command}\" failed.")
    end
  end

  def bundle(subcommand)
    shell "bundle #{subcommand}"
  end

  def bundle_exec(subcommand)
    bundle "exec #{subcommand}"
  end

  def bundled_rake(task)
    bundle_exec "rake #{task}"
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
    heroku "run rake db:migrate", :repo => repo
  end

  def deploy(repo)
    puts "Deploying to #{heroku_app(repo)}"
    push repo
    migrate repo
  end

  def y_or_n?(text)
    text.strip.downcase == 'y'
  end

  def with_confirmation(task_summary)
    puts "Are you sure you want to #{task_summary} ? (y/n)"
    answer = STDIN.readline
    if y_or_n?(answer)
      yield
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

  def import_tester_repos
    0.upto(6).map { |i| "import-tester-#{i}" }
  end

  def test_and_integration_repos
    import_tester_repos + ["cart-tester", "integ"]
  end

  def integrate
    puts "\nInstalling dependencies"
    bundle "install"

    puts "\nRunning integration script"
    bundled_rake "behaviours"

    puts "\nPushing to main source repository"
    push "main"

    puts "\nDeploying to test and integration environments"
    parallel_deploy(test_and_integration_repos)

    puts "\nIntegration successful :-)"
  end

  def create_heroku_app(repo)
    heroku "apps:create --remote #{repo} --stack #{HEROKU_STACK} #{heroku_app(repo)}"

    heroku "addons:add cron:daily", :repo => repo
    heroku "addons:upgrade logging:expanded", :repo => repo
    heroku "addons:add sendgrid:starter", :repo => repo

    heroku "config:add CRON_TASKS=stores:import HIREFIRE_EMAIL=philippe.bourgau@gmail.com HIREFIRE_PASSWORD=J\\'ai\\ 2\\ nikes\\ air\\ au\\ cou\\!", :repo => repo
  end

  private

  def print_help(name, description)
      puts description
      puts
      puts "  ruby script/#{name}"
      puts
  end

  def parallel_deploy(repos)
    pids_2_repos = launch_deployment_processes(repos)
    deploy_statuses = Process.waitall
    print_deployment_logs(repos)
    forward_failure(deploy_statuses, pids_2_repos)
  end

  def launch_deployment_processes(repos)
    pids_2_repos = {}
    repos.each do |repo|
      pid = fork do
        $stderr = $stdout = File.new(deploy_temp_log(repo), "w")
        deploy(repo)
      end
      pids_2_repos[pid] = repo
    end
    return pids_2_repos
  end

  def print_deployment_logs(repos)
    repos.each do |repo|
      IO.foreach(deploy_temp_log(repo)) {|line| puts line}
    end
  end

  def forward_failure(deploy_statuses, pids_2_repos)
    success = deploy_statuses.all? {|pid, status| status.success? }
    unless success
      message = ["Deployment failed :-("]
      deploy_statuses.each do |pid, status|
        unless status.success?
          message << "   Deployment to #{pids_2_repos[pid]} failed with status #{status.exitstatus}"
        end
      end
      raise RuntimeError.new(message.join("\n"))
    end
  end

  def deploy_temp_log(repo)
    "/tmp/deployment_to_#{heroku_app(repo)}.log"
  end

end