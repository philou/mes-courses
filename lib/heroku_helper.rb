# Copyright (C) 2011 by Philippe Bourgau

module HerokuHelper

  def on_heroku?
    !ENV['APP_NAME'].nil?
  end
  def HerokuHelper.app_name
    ENV['APP_NAME'] || "<Not_an_Heroku_app>"
  end
  def app_name
    HerokuHelper.app_name
  end
  def heroku_login
    ENV['HIREFIRE_EMAIL']
  end
  def heroku_password
    ENV['HIREFIRE_PASSWORD']
  end

  def heroku_logs
    logs = []

    Heroku::Client.new(heroku_login, heroku_password).read_logs(app_name) do |chunk|
      logs.push(chunk)
    end

    logs.join("\n")
  end

  def safe_heroku_logs
    if on_heroku?
      heroku_logs
    else
      "Not on heroku, no logs available."
    end
  rescue => e
    "Failed to collect logs : #{e}\n#{e.backtrace}"
  end


end
