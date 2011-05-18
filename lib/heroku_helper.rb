# Copyright (C) 2011 by Philippe Bourgau

module HerokuHelper

  def on_heroku?
    !ENV['APP_NAME'].nil?
  end

  def app_name
    ENV['APP_NAME'] || "<Not_an_Heroku_app>"
  end

end
