# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module MesCourses
  module Utils
    module ScheduledTasks

      def scheduled_task(target)
        desc "Schedules #{target} task, define #{day_of_week_key(target)} to limit runs to the specified day of week."
        task target => :environment do
          begin
            if not ScheduledTasks.should_run_today(target)
              Rails.logger.info "Skipping #{target} this day of the week"
            else
              Rake::Task[target].invoke
            end
          rescue Exception => e
            CronTaskFailureReporter.failure(target, e).deliver
          end
        end
      end

      def day_of_week_key(name)
        "#{name.to_s.gsub(':','_').upcase}_DAY_OF_WEEK"
      end
      module_function :day_of_week_key

      private

      def self.should_run_today(name)
        day_of_week(name).nil? or Time.now.wday == day_of_week(name).to_i
      end

      def self.day_of_week(name)
        ENV[day_of_week_key(name)]
      end

    end
  end
end
