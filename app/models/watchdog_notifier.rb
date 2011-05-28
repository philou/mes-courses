# Copyright (C) 2011 by Philippe Bourgau

# Objects responsible for building and sending watchdog notification emails
class WatchdogNotifier < ActionMailer::Base
  include HerokuHelper

  # mailer template function
  def success_email
    @subject = "[#{app_name}] Watchdog OK"
    @body["content"] = "All specs OK."
    @recipients = EmailConstants.recipients
    @from = EmailConstants.sender
    @sent_on = Time.now
    @headers = {}
  end
end
