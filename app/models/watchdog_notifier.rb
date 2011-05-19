# Copyright (C) 2011 by Philippe Bourgau

# Objects responsible for building and sending watchdog notification emails
class WatchdogNotifier < ActionMailer::Base
  include HerokuHelper

  # mailer template function
  def success_email
    @subject = "[#{app_name} WATCHDOG SUCCESS]"
    @body["content"] = "All tests OK."
    @recipients = 'philippe.bourgau@mes-courses.fr'
    @from = 'watchdog@mes-courses.fr'
    @sent_on = Time.now
    @headers = {}
  end
end
