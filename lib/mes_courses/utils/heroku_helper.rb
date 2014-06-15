# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


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
        "https://api.heroku.com/myapps/#{app_name}/addons/papertrail:choklad"
      end
    end
  end
end
