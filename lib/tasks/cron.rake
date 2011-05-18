# Copyright (C) 2010, 2011 by Philippe Bourgau

require "exception_notification/notified_task"

desc "Performs nightly tasks, at the moment, importing items from stores"
cron_task = NotifiedTask.new :cron => :environment do
  cron_tasks = ENV['CRON_TASKS'] || ""
  cron_tasks.split(';').each do |task|
    Rake::Task[task].invoke
  end
end

# Monkey patching NotifiedTask to have a logger
class << cron_task
  def logger
    Rails.logger
  end
end
