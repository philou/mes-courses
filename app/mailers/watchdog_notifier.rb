# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

# Objects responsible for building and sending watchdog notification emails
class WatchdogNotifier < MesCourses::RailsUtils::MonitoringMailerBase
  extend MesCourses::Utils::HerokuHelper

  def success_email
    @content = "All specs OK.\n\n#{safe_heroku_logs}"
    setup_mail("Watchdog OK")
  end

end
