# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test cucumber ci)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

# Load lib files
require_relative "../lib/mes_courses"
require_relative "../lib/mes_courses/utils/heroku_helper"
require_relative "../lib/mes_courses/utils/email_constants"

require 'pp'

module MesCourses
  class Application < Rails::Application
    include Utils::HerokuHelper
    include Utils::EmailConstants

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Paris'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Force ssl for the whole app on heroku
    # config.force_ssl = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Change the path that assets are served from
    # config.assets.prefix = "/assets

    # Precompile blog.css and app.css
    config.assets.precompile += [/blog.css/, /app.css/]

    # Suggested by devise : on heroku, do not access the DB or load models when
    # precompiling your assets
    if on_heroku?
      config.assets.initialize_on_precompile = false
    end

    # Send emails from heroku
    if !on_heroku?
      config.action_mailer.delivery_method = :test
      config.action_mailer.default_url_options = { :host => 'localhost' }

    else
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.default_url_options = { :host => "#{app_name}.heroku.com" }
      ActionMailer::Base.smtp_settings = {
        :address        => 'smtp.sendgrid.net',
        :port           => '25',
        :authentication => :plain,
        :user_name      => ENV['SENDGRID_USERNAME'],
        :password       => ENV['SENDGRID_PASSWORD'],
        :domain         => ENV['SENDGRID_DOMAIN']}
    end

    # setup exception notifier on heroku
    if on_heroku?
      config.middleware.use ExceptionNotifier,
        :email_prefix => "[#{app_name}] ERROR ",
        :sender_address => sender,
        :exception_recipients => recipients
    end

    # ssl everywhere appart from orders, where store logout through an
    # http iframe might be insecure
    if on_heroku?
      config.middleware.use Rack::SslEnforcer, except: "/orders", strict: true
    end
  end
end
