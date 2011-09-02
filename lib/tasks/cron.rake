# Copyright (C) 2010, 2011 by Philippe Bourgau

require "exception_notification/notified_task"
require "lib/heroku_helper"

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
  include HerokuHelper

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

  def exception_data
    lambda do
      { :log => safe_heroku_logs}
    end
  end
  def safe_heroku_logs
    begin
      if on_heroku?
        heroku_logs
      else
        "Not on heroku, no logs available."
      end
    rescue Exception => e
      "Failed to collect logs : #{e}\n#{e.backtrace}"
    end
  end

end

desc "Testing task that always fails"
task :failing do
  raise Exception.new("This task always fails")
end

