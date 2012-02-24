# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

desc "Checks all specs, then drops, creates, and migrates the db, finaly runs all scenarios"
task :behaviours => [:spec, :remote_spec, :ci, 'db:migrate:reset', :cucumber]

desc "Sets rails in ci mode"
task :ci do
  ENV['RAILS_ENV'] = RAILS_ENV = 'ci'
end

desc "Tasks that launches the remote specs and emails a result"
task :watchdog => :remote_spec do
  WatchdogNotifier.deliver_success_email
end

