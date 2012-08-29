# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

desc "Performs tasks, specified in the CRON_TASKS environment variable as a ; separated list"
task :cron => :environment do

  if not cron_should_run_today
    Rails.logger.info "Skipping cron this day of the week"
  else
    cron_tasks.split(';').each do |task|
      begin
        Rake::Task[task].invoke
      rescue Exception => e
        CronTaskFailureReporter.failure(task, e).deliver
      end
    end
  end
end

def cron_should_run_today
  import_day.nil? or Time.now.wday == import_day.to_i
end
def import_day
  ENV['CRON_DAY_OF_WEEK']
end
def cron_tasks
  tasks = ENV['CRON_TASKS'] || ""
  tasks.split(';')
end

desc "Testing task that always fails"
task :failing do
  raise StandardError.new("This task always fails")
end

