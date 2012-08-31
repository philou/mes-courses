# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

unless Rails.env == "production"

  desc "Checks all specs, then drops, creates, and migrates the db, finaly runs all scenarios"
  task :behaviours => [:spec, :ci, 'db:migrate:reset', :cucumber]

  desc "Sets rails in ci mode"
  task :ci do
    ENV['RAILS_ENV'] = Rails.env = 'ci'
  end

  desc "Tasks that launches the remote specs and emails a result"
  task :watchdog => [:environment, :remote_spec] do
    WatchdogNotifier.success_email.deliver
  end

end

desc "Testing task that always fails"
task :failing do
  raise StandardError.new("This task always fails")
end

