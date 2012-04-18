# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

# base mailer class for online maintainer monitoring
class MonitoringMailer < ActionMailer::Base
  include HerokuHelper

  default :from => EmailConstants.sender, :to => EmailConstants.recipients

  def setup_mail(subject)
    mail :subject => "[#{app_name}] " + subject, :date => Time.now
  end
end
