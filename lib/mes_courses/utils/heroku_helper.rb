# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses
  module Utils
    module HerokuHelper

      def HerokuHelper.on_heroku?
        !ENV['APP_NAME'].nil?
      end
      def HerokuHelper.app_name
        ENV['APP_NAME'] || "<Not_an_Heroku_app>"
      end
      def HerokuHelper.heroku_login
        ENV['HIREFIRE_EMAIL']
      end
      def HerokuHelper.heroku_password
        ENV['HIREFIRE_PASSWORD']
      end
      def HerokuHelper.safe_heroku_logs
        if on_heroku?
          heroku_logs
        else
          "Not on heroku, no logs available."
        end
      rescue => e
        "Failed to collect logs : #{e}\n#{e.backtrace}"
      end


      def on_heroku?
        HerokuHelper.on_heroku?
      end
      def app_name
        HerokuHelper.app_name
      end
      def heroku_login
        HerokuHelper.heroku_login
      end
      def heroku_password
        HerokuHelper.heroku_password
      end
      def safe_heroku_logs
        HerokuHelper.safe_heroku_logs
      end

      private

      def HerokuHelper.heroku_logs
        logs = []

        Heroku::Client.new(heroku_login, heroku_password).read_logs(app_name) do |chunk|
          logs.push(chunk)
        end

        logs.join("\n")
      end
    end
  end
end
