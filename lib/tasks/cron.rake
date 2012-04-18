# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require "heroku_helper"

desc "Performs tasks, specified in the CRON_TASKS environment variable as a ; separated list"
task :cron => :environment do

  tasks = ENV['CRON_TASKS'] || ""

  tasks.split(';').each do |task|
    cron_task.sub_cron_task= task
    Rake::Task[task].invoke
  end

end

# Monkey patching NotifiedTask to have a logger
# class << cron_task
#   include HerokuHelper

#   def logger
#     Rails.logger
#   end

#   def to_s
#     "Cron rake task"
#   end

#   attr_accessor :sub_cron_task
#   def action_name
#     sub_cron_task || ""
#   end

#   def extra_exception_data
#     { :log => safe_heroku_logs}
#   end

# end

# class NotifiedTask
#   def self.exception_data
#     :extra_exception_data
#   end
# end

desc "Testing task that always fails"
task :failing do
  raise StandardError.new("This task always fails")
end

