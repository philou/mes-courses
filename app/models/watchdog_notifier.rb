# Copyright (C) 2011 by Philippe Bourgau

# Objects responsible for building and sending watchdog notification emails
class WatchdogNotifier < MonitoringMailer
  extend HerokuHelper

  def success_email
    setup_mail("Watchdog OK", "content" => "All specs OK.\n\n#{safe_heroku_logs}")
  end

end
