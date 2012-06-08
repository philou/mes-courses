# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

# Use a custom cucumber env so that I can use a different db than test
ENV['RAILS_ENV'] ||= 'cucumber'

require 'cucumber/rails'


# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove/comment out the lines below if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

# You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
# See the DatabaseCleaner documentation for details. Example:
#
#   Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
#     # { :except => [:widgets] } may not do what you expect here
#     # as tCucumber::Rails::Database.javascript_strategy overrides
#     # this setting.
#     DatabaseCleaner.strategy = :truncation
#   end
#
#   Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
#     DatabaseCleaner.strategy = :transaction
#   end
#

# Possible values are :truncation and :transaction
# The :transaction strategy is faster, but might give you threading problems.
# See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
Cucumber::Rails::Database.javascript_strategy = :truncation

# Factory girl steps
require "factory_girl"
Dir[Rails.root.join("spec/factories/*.rb")].each {|f| require f}
require "factory_girl/step_definitions"

# custom matchers
require File.join(Rails.root, 'spec/support/constants')
require File.join(Rails.root, 'spec/support/mostly_matcher')
require File.join(Rails.root, 'spec/support/all_do_matcher')
require File.join(Rails.root, 'spec/support/have_non_nil_matcher')
require File.join(Rails.root, 'spec/support/have_place_matcher')
require File.join(Rails.root, 'spec/support/highlight_place_matcher')
require File.join(Rails.root, 'spec/support/have_body_id_matcher')

# Add the capability to retreive and store db metrics in an active record model
class ActiveRecord::Base
  # Current db model metrics
  def self.current_metrics
    {
      :count => count,
      :updated_at => maximum(:updated_at),
      :created_at => maximum(:created_at),
      :all => find(:all)
    }
  end

  def self.past_metrics
    @past_metrics
  end

  # Fills metrics from the db, NOW!
  def self.collect_past_metrics
    @past_metrics = current_metrics
  end
end

# Reimports a store, waits for the next second
# records db metrics before reimporting
def reimport(store)

  [Item, ItemCategory].each do |record|
    record.collect_past_metrics
  end

  [Item, ItemCategory].each do |record|
    while record.past_metrics[:updated_at].sec == Time.now.sec
      sleep(0.01)
    end
  end

  Store.import
end
