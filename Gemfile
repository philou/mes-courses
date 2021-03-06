source 'https://rubygems.org'
ruby '2.0.0'

gem 'thin'
gem 'rails', '< 4.0'
gem 'nokogiri', :require => 'nokogiri' # to avoid could not find nokogiri-xxx in any of the sources while running rake db:migrate on heroku
gem 'mechanize'
gem 'exception_notification', '< 4.0', :require => 'exception_notifier'
gem 'delayed_job_active_record', '< 4.0'
gem 'workless', :group => [:production, :development] # we don't want workless poluting our tests
gem 'heroku-api'
gem 'foreigner'
gem 'acts_as_tree'
gem 'devise'
gem 'blogit'
gem 'jquery-rails'
gem 'rack-ssl-enforcer'
gem 'rack-cache', :require => 'rack/cache'
gem 'encryptor'
gem 'auchandirect-scrAPI'

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
gem 'rspec-rails'
gem 'factory_girl_rails', :require => false # lazy require for guard/spring
gem 'webrat'
gem 'cucumber-rails', :require => false
gem 'database_cleaner'
gem 'timecop'
gem 'email_spec'
gem 'spec_combos'
gem 'xpath-specs'
gem 'rspecproxies'
gem 'cucumber_tricks'

# developpment only tools
group :test, :development, :ci do
  gem 'jasmine'
  gem 'jasminerice'

  gem 'spring'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-rails'
  gem 'guard-jasmine'

  gem 'launchy'
  # gem 'debugger'
end
