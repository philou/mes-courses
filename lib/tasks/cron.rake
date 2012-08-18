# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

desc "Performs tasks, specified in the CRON_TASKS environment variable as a ; separated list"
task :cron => :environment do

  tasks = ENV['CRON_TASKS'] || ""

  tasks.split(';').each do |task|
    begin
      Rake::Task[task].invoke

    rescue Exception => e
      CronTaskFailureReporter.failure(task, e).deliver

    end
  end

end

desc "Testing task that always fails"
task :failing do
  raise StandardError.new("This task always fails")
end

