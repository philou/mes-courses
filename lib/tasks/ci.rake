# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

unless Rails.env == "production"

  desc "Runs all specs, and scenarios"

  task :behaviours => [:spec, :behaviours_env, "assets:precompile", :cucumber, :csslint, "db:fixtures:load", "cucumber:dry_run"]

  desc "Sets RAILS_ENV to BEHAVIOURS_ENV"
  task :behaviours_env do
    if (env = ENV["BEHAVIOURS_ENV"])
      ENV['RAILS_ENV'] = Rails.env = env
    end
  end

  desc "Launches the remote specs and emails a result"
  task :watchdog => [:environment, :remote_spec] do
    WatchdogNotifier.success_email.deliver
  end

  desc "Runs csslint and prints errors"
  task :csslint => [:environment] do
    command = "csslint app/assets/stylesheets/"
    if not system command
      raise RuntimeError.new("Command \"#{command}\" failed.")
    end
  end

end

desc "Testing task that always fails"
task :failing do
  raise StandardError.new("This task always fails")
end

