# Copyright (C) 2010 by Philippe Bourgau

desc "Checks all specs, then drops, creates, and migrates the db, finaly runs all scenarios"
task :behaviours => [:ci,
                     :spec,
                     'db:drop',
                     'db:create',
                     'db:migrate',
                     :cucumber]

desc "Sets rails in ci mode"
task :ci do
  ENV['RAILS_ENV'] = RAILS_ENV = 'ci'
end
