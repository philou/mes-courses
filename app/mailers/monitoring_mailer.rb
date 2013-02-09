# Copyright (C) 2013 by Philippe Bourgau

class MonitoringMailer < MesCourses::RailsUtils::MonitoringMailerBase
  def ping
    setup_mail("Ping")
  end
end
