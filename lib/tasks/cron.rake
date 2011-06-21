# Copyright (C) 2010, 2011 by Philippe Bourgau

require "exception_notification/notified_task"

desc "Performs tasks, specified in the CRON_TASKS environment variable as a ; separated list"
cron_task = NotifiedTask.new :cron => :environment do

  tasks = ENV['CRON_TASKS'] || ""

  tasks.split(';').each do |task|
    cron_task.sub_cron_task= task
    Rake::Task[task].invoke
  end

end

# Monkey patching NotifiedTask to have a logger
class << cron_task
  def logger
    Rails.logger
  end

  def to_s
    "Cron rake task"
  end

  attr_accessor :sub_cron_task
  def action_name
    sub_cron_task || ""
  end

end
