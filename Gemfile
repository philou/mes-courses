source 'https://rubygems.org'

gem 'rails'
gem "mechanize"
gem "exception_notification", :require => 'exception_notifier'
gem "delayed_job_active_record"
gem "workless", :group => [:production, :development]
gem "heroku-api"
gem "foreigner"
gem 'acts_as_tree'
gem 'devise'
gem 'blogit', :git => 'git://github.com/KatanaCode/blogit.git'
gem 'jquery-rails'
gem 'lazing', :git => 'git://github.com/philou/lazing.git'
gem 'rack-ssl-enforcer'
gem 'rack-cache', :require => 'rack/cache'

# required on heroku
gem 'therubyracer', :require => 'v8'

# databases
gem "pg", :group => [:production, :ci, :cucumber, :development]
gem "sqlite3", :require => "sqlite3", :group => [:test]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# testing tools
gem "spork", :group => [:development, :test, :cucumber, :ci]
gem "rspec-rails", :group => [:development, :test, :cucumber, :ci]
gem "factory_girl_rails", :group => [:test, :cucumber, :ci], :require => false
gem "webrat", :group => [:test]
gem "autotest-rails", :group => [:development]
gem "autotest-notification", :group => [:development]
gem "cucumber-rails", :group => [:test]
gem "database_cleaner", :group => [:cucumber, :ci]
gem 'net-ping', :git => 'git://github.com/djberg96/net-ping.git', :group => [:test, :ci]

# developpment tools
# gem "debugger", :group => [:development, :test, :cucumber]
