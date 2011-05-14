# Copyright (C) 2010, 2011 by Philippe Bourgau

desc "Checks all specs, then drops, creates, and migrates the db, finaly runs all scenarios"
task :behaviours => [:ci, 'db:drop', 'db:create', 'db:migrate', :spec, :cucumber, :remote_spec]

desc "Sets rails in ci mode"
task :ci do
  ENV['RAILS_ENV'] = RAILS_ENV = 'ci'
  sh "bundle install"
end
