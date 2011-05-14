# Copyright (C) 2010, 2011 by Philippe Bourgau

desc "Performs nightly tasks, at the moment, importing items from stores"
task :cron => :environment do
  Rails.logger.mongoize do
    at_exit do
      Rails.logger.info "Exited, last exception was #{$!.inspect}"
    end

    cron_tasks = ENV['CRON_TASKS'] || ""
    cron_tasks.split(';').each do |task|
      Rake::Task[task].invoke
    end

  end
end
