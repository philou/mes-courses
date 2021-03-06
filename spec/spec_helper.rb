# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012, 2013, 2014 by Philippe Bourgau
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


# figure out where we are being loaded from
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
===================================================
It looks like spec_helper.rb has been loaded
multiple times. Normalize the require to:

  require "spec/spec_helper"

Things like File.join and File.expand_path will
cause it to be loaded multiple times.

Loaded this time from:

  #{e.backtrace.join("\n    ")}
===================================================
  MSG
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'

# Uncomment the next line to use webrat's matchers
# require 'webrat/integrations/rspec-rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# dummy store generation
require 'storexplore/testing'
Storexplore::Testing.config do |config|
  config.dummy_store_generation_dir= File.join(Rails.root, 'tmp')
end

extend MesCourses::Utils::HerokuHelper

RSpec.configure do |config|

  # RSpec automatically cleans stuff out of backtraces;
  # sometimes this is annoying when trying to debug something e.g. a gem
  if ENV['FULLBACKTRACES'] == 'true'
    config.backtrace_exclusion_patterns = []
  end

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.include(AuthenticationControllerMacros, :type => :controller)

  # Email testing
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
  config.before :each do
    ActionMailer::Base.deliveries.clear
  end
end

# Setup sqlite in memory database for speedup
unless on_heroku?
  setup_sqlite_db = lambda do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

    load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default
    # ActiveRecord::Migrator.up('db/migrate') # use migrations
  end
  silence_stream(STDOUT, &setup_sqlite_db)
end
