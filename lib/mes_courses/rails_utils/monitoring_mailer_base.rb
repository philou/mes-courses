# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module RailsUtils

    # base mailer class for online maintainer monitoring
    class MonitoringMailerBase < ActionMailer::Base
      include MesCourses::Utils::HerokuHelper
      extend MesCourses::Utils::EmailConstants

      default :from => watchdog_email, :to => maintainers_emails

      def setup_mail(subject)
        mail :subject => "[#{app_name}] " + subject, :date => Time.now
      end
    end
  end
end
