# Copyright (C) 2011 by Philippe Bourgau

require 'time_span_helper'

module DeploymentHelpers

  def DeploymentHelpers.shell(command)
    unless system command
      raise RuntimeError.new("Command \"#{command}\" failed.")
    end
  end

  def DeploymentHelpers.bundle(subcommand)
    shell "bundle #{subcommand}"
  end

  def DeploymentHelpers.bundled_rake(task)
    bundle "exec rake #{task}"
  end

  def DeploymentHelpers.pull(repo)
    shell "git pull #{repo} master"
  end
  def DeploymentHelpers.push(repo)
    shell "git push #{repo} master"
  end

  def DeploymentHelpers.git_repo(app)
    prefix = "mes-courses-"

    raise ArgumentError.new("heroku application '#{app}' does not start with 'mes-courses-'") unless app.starts_with?(prefix)

    app[prefix.length..-1]
  end

  def DeploymentHelpers.migrate(app)
    shell "heroku rake db:migrate --app #{app}"
  end

  def DeploymentHelpers.deploy(app)
    puts "Deploying to #{app}"
    push git_repo(app)
    migrate app
  end

  def DeploymentHelpers.y_or_n?(text)
    text.strip.downcase == 'y'
  end

  def DeploymentHelpers.with_confirmation(task_summary)
    puts "Are you sure you want to #{task_summary} ? (y/n)"
    answer = STDIN.readline
    if y_or_n?(answer)
      yield
    end
  end

  def DeploymentHelpers.with_timing
    Timing.duration_of do |timer|
      begin
        yield
      ensure
        puts "\nTook #{timer.seconds.to_pretty_duration}"
      end
    end
  end

  def DeploymentHelpers.import_tester_apps
    0.upto(6).map { |i| "mes-courses-import-tester-#{i}" }
  end
  def DeploymentHelpers.test_and_integration_apps
    import_tester_apps + ["mes-courses-cart-tester", "mes-courses-integ"]
  end

end

namespace :mes_courses do

  desc "Deploys master branch to the specified remote heroku app (ex: app=mes-courses-integ)"
  task :deploy do
    app = ENV["app"]
    raise ArgumentError.new("An heroku app to push to must be specified") unless !app.nil?
    DeploymentHelpers::with_confirmation("deploy master branch to the \"#{app}\" heroku app") do
      DeploymentHelpers::deploy(app)
    end
  end

  desc "Integrates the latest developments to the main repository, deploys to test and integration heroku applications"
  task :integrate do
    DeploymentHelpers::with_confirmation("integrate the latest developments") do
      DeploymentHelpers::with_timing do

        puts "\nPulling latest developments"
        DeploymentHelpers::pull "dev"

        puts "\nInstalling dependencies"
        DeploymentHelpers::bundle "install"

        puts "\nRunning integration script"
        DeploymentHelpers::bundled_rake "behaviours"

        puts "\nPushing to main source repository"
        DeploymentHelpers::push "main"

        puts "\nDeploying to test and integration environments"
        DeploymentHelpers::test_and_integration_apps.each do |app|
          DeploymentHelpers::deploy(app)
        end

        puts "\nIntegration successful !"
      end
    end
  end

  desc "prints the names of all import tester apps (launch with rake -s to get rid of the 'in directory' announcement)"
  task :import_testers do
    DeploymentHelpers::import_tester_apps.each do |app|
      puts app
    end
  end

  desc "prints the names of all test and integration apps (launch with rake -s to get rid of the 'in directory' announcement)"
  task :test_and_integration_apps do
    DeploymentHelpers::test_and_integration_apps.each do |app|
      puts app
    end
  end

end
