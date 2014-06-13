# Copyright (C) 2014 by Philippe Bourgau


if on_heroku?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.default_url_options = { :host => "#{app_name}.herokuapp.com" }

else
  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.default_url_options = { :host => 'localhost' }

end
