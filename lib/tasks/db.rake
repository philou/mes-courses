# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

namespace :db do

  desc "Imports a db from heroku to the current environment"
  task :import_heroku, [:heroku_app] => [:environment] do |t, args|
    heroku_app = args[:heroku_app]
    config = Rails.configuration.database_configuration[Rails.env]

    raise StandardError.new('Only works with postgresql databases') unless config['adapter'] == 'postgresql'

    system "heroku pgbackups:capture --app #{heroku_app}" and
    system "curl -o tmp/latest_db.dump `heroku pgbackups:url --app #{heroku_app}`" and
    system "pg_restore --verbose --clean --no-acl --no-owner -h #{config['host']} -U #{config['username']} -d #{config['database']} tmp/latest_db.dump"
  end
end
