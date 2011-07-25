# Copyright (C) 2011 by Philippe Bourgau

# base mailer class for online maintainer monitoring
class MonitoringMailer < ActionMailer::Base
  include HerokuHelper

  def setup_mail(subject, body = {})
    @subject = "[#{app_name}] " + subject
    @body = body
    @recipients = EmailConstants.recipients
    @from = EmailConstants.sender
    @sent_on = Time.now
    @headers = {}
  end
end
