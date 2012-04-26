# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

# Object responsible for mailing cron task failures
class CronTaskFailureReporter < MonitoringMailer
  include HerokuHelper

  def failure(task_name, exception)
    setup_content(exception)
    setup_mail(subject(task_name, exception))
  end

  private

  def setup_content(exception)
    @backtrace = exception.backtrace.join("\n")
    @logs = safe_heroku_logs
  end

  def subject(task_name, exception)
    "ERROR task '#{task_name}' (#{exception.class.name}) #{exception.message}"
  end
end
