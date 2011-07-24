# Copyright (C) 2011 by Philippe Bourgau

class BrokenDishesReporter < ActionMailer::Base
  include HerokuHelper

  def email items
    @subject = "[#{app_name}] There are broken dishes"
    @body["items"] = items
    @recipients = EmailConstants.recipients
    @from = EmailConstants.sender
    @sent_on = Time.now
    @headers = {}
  end

end
