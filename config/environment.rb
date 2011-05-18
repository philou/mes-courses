# Copyright (C) 2010, 2011 by Philippe Bourgau

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'exception_notification'
require 'lib/heroku_helper'

Rails::Initializer.run do |config|
  include HerokuHelper

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # By default, don't send emails
  config.action_mailer.delivery_method = :test

  ExceptionNotification::Notifier.configure_exception_notifier do |config|
    # If left empty web hooks will not be engaged
    # config[:web_hooks] = []

    config[:app_name]                 = ENV['APP_NAME']
    config[:sender_address]           = "philippe.bourgau@mes-courses.fr"
    config[:exception_recipients]     = ["philippe.bourgau@mes-courses.fr"]

    # Customize the subject line
    # config[:subject_prepend] = "[#{(defined?(Rails) ? Rails.env : RAILS_ENV).capitalize} ERROR] "
    # config[:subject_append] = nil
    # Include which sections of the exception email?
    # config[:sections] = %w(request session environment backtrace)
    # Only use this gem to render, never email
    # defaults to false - meaning by default it sends email. Setting true will cause it to only render the error pages, and NOT email.
    # config[:skip_local_notification] = true
    # Example:
    # config[:view_path] = 'app/views/error'
    # config[:view_path] = nil
    # Error Notification will be sent if the HTTP response code for the error matches one of the following error codes
    config[:notify_error_codes] = %W( 405 500 503 )
    # Error Notification will be sent if the error class matches one of the following error error classes
    # config[:notify_error_classes] = %W( )
    # What should we do for errors not listed?
    config[:notify_other_errors] = true
    # config[:template_root] = "#{File.dirname(__FILE__)}/../views"
    # If you set this SEN will attempt to use git blame to discover the person who made the last change to the problem code
    # config[:git_repo_path]            = nil # ssh://git@blah.example.com/repo/webapp.git
   end
end
