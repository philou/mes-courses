# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau

require 'spork'

Spork.prefork do

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
  require 'rspec/autorun'

  extend MesCourses::Utils::HerokuHelper

  # Require factory girl
  require 'factory_girl_rails'

  # Uncomment the next line to use webrat's matchers
  # require 'webrat/integrations/rspec-rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  include OfflineTestHelper

  RSpec.configure do |config|
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
  end

end

Spork.each_run do
  # Load schema for in memory sqlite database
  unless on_heroku?
    load_schema = lambda do
      load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default
      # ActiveRecord::Migrator.up('db/migrate') # use migrations
    end
    silence_stream(STDOUT, &load_schema)
  end
end
