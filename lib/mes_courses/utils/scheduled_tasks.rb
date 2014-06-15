# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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


require_relative("../notifications/by_mail")

module MesCourses
  module Utils
    module ScheduledTasks

      def scheduled_task(target)
        include MesCourses::Notifications::ByMail

        desc "Schedules #{target} task, define #{day_of_week_key(target)} to limit runs to the specified day of week."
        task target => :environment do
          begin
            if not ScheduledTasks.should_run_today(target)
              Rails.logger.info "Skipping #{target} this day of the week"
            else
              Rake::Task[target].invoke
            end

          rescue Exception => e
            notify_scheduled_task_failure(target, e)
          end
        end
      end

      def day_of_week_key(name)
        "#{name.to_s.gsub(':','_').upcase}_DAY_OF_WEEK"
      end
      module_function :day_of_week_key

      private

      def self.should_run_today(name)
        day_of_week(name).nil? or Time.now.getutc.wday == day_of_week(name).to_i
      end

      def self.day_of_week(name)
        ENV[day_of_week_key(name)]
      end

    end
  end
end
