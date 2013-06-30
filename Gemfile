source 'https://rubygems.org'
ruby '2.0.0'

gem 'thin'
gem 'rails'
gem 'mechanize'
gem 'exception_notification', :require => 'exception_notifier'
gem 'delayed_job_active_record'
gem 'workless', :group => [:production, :development] # we don't want workless poluting our tests
gem 'heroku-api'
gem 'foreigner'
gem 'acts_as_tree'
gem 'devise'
gem 'blogit'
gem 'jquery-rails'
gem 'lazing', :git => 'git://github.com/philou/lazing.git'
gem 'rack-ssl-enforcer'
gem 'rack-cache', :require => 'rack/cache'
gem 'encryptor'

# databases
gem 'pg'
gem 'sqlite3', :require => 'sqlite3', :group => [:test] # it does not install on heroku

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# testing tools, required in watchdog prod env
gem 'rspec-rails', '>= 2.12.0'
gem 'factory_girl_rails', :require => false # lazy require factories at each spork run
gem 'webrat'
gem 'cucumber-rails', :require => false
gem 'database_cleaner'
gem 'net-ping', :git => 'git://github.com/djberg96/net-ping.git'
gem 'spork'
gem 'timecop'

# developpment only tools
group :test, :development, :cucumber, :ci do
  gem 'jasmine'
  gem 'jasmine-jquery-rails'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem 'guard-jasmine'

  # gem 'debugger'
end
