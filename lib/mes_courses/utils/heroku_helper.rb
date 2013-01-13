# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Utils
    module HerokuHelper

      def HerokuHelper.on_heroku?
        !ENV['APP_NAME'].nil?
      end
      def HerokuHelper.app_name
        ENV['APP_NAME'] || "<Not_an_Heroku_app>"
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
      def safe_heroku_logs
        HerokuHelper.safe_heroku_logs
      end

      private

      def HerokuHelper.heroku_logs
        "https://api.heroku.com/myapps/#{app name}/addons/papertrail:choklad"
      end
    end
  end
end
