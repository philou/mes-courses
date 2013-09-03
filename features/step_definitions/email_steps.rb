# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

Then(/^I should receive "(.*?)" at (#{CAPTURE_EMAIL})$/) do |subject, receiver, content|
  an_email_must_have_been_sent(subject, receiver, content)
end

Then(/^I should not receive anything at (#{CAPTURE_EMAIL})$/) do |receiver|
  no_emails_should_have_been_sent_to(receiver)
end
