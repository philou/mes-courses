# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::RailsUtils

  # base mailer class for online maintainer monitoring
  class MonitoringMailer < ActionMailer::Base
    include MesCourses::Utils::HerokuHelper
    extend MesCourses::Utils::EmailConstants

    default :from => sender, :to => recipients

    def setup_mail(subject)
      mail :subject => "[#{app_name}] " + subject, :date => Time.now
    end
  end
end
