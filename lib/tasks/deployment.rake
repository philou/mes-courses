# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'lib/time_span_helper'

module DeploymentHelpers

  HEROKU_STACK = "bamboo-ree-1.8.7"

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
    heroku "rake db:migrate", :repo => repo
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

  def import_tester_repos
    0.upto(6).map { |i| "import-tester-#{i}" }
  end
  def test_and_integration_repos
    import_tester_repos + ["cart-tester", "integ"]
  end

end

namespace :mes_courses do
  include DeploymentHelpers

  desc "Deploys master branch to the specified remote heroku app (ex: repo=integ)"
  task :deploy do
    repo = ENV["repo"]
    raise ArgumentError.new("An heroku git repo to push to must be specified") unless !repo.nil?
    with_confirmation("deploy master branch to the \"#{repo}\" heroku git repo") do
      deploy(repo)
    end
  end

  desc "Integrates the latest developments to the main repository, deploys to test and integration heroku applications"
  task :integrate do
    with_confirmation("integrate the latest developments") do
      with_timing do

        puts "\nPulling latest developments"
        pull "dev"

        puts "\nInstalling dependencies"
        bundle "install"

        puts "\nRunning integration script"
        bundled_rake "behaviours"

        puts "\nPushing to main source repository"
        push "main"

        puts "\nDeploying to test and integration environments"
        test_and_integration_repos.each do |repo|
          deploy(repo)
        end

        puts "\nIntegration successful !"
      end
    end
  end

  desc "prints the names of all import tester apps (launch with rake -s to get rid of the 'in directory' announcement)"
  task :import_testers do
    import_tester_repos.each do |repo|
      puts heroku_app(repo)
    end
  end

  desc "prints the names of all test and integration apps (launch with rake -s to get rid of the 'in directory' announcement)"
  task :test_and_integration_apps do
    test_and_integration_repos.each do |repo|
      puts heroku_app(repo)
    end
  end

  desc "create an heroku app with the corresponding git remote (ex repo=dev)"
  task :create_heroku_app do
    repo = ENV["repo"]
    raise ArgumentError.new("An heroku git repo name must be specified") unless !repo.nil?
    heroku "apps:create --remote #{repo} --stack #{HEROKU_STACK} #{heroku_app(repo)}"

    heroku "addons:add cron:daily", :repo => repo
    heroku "addons:upgrade logging:expanded", :repo => repo
    heroku "addons:add sendgrid:starter", :repo => repo

    heroku "config:add CRON_TASKS=stores:import HIREFIRE_EMAIL=philippe.bourgau@free.fr HIREFIRE_PASSWORD=No@hRUle$", :repo => repo
  end
end
