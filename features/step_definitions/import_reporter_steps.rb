# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

def find_email(subject)
  emails = ActionMailer::Base.deliveries
  emails.find { |email| email.subject =~ Regexp.new(subject) }
end

Then /^an email ~"([^"]*)" should be sent to the maintainer"?$/ do |subject|
  find_email(subject).should_not be_nil
end

Then /^an email ~"([^"]*)" containing "([^"]*)" and "([^"]*)" should be sent to the maintainer"?$/ do |subject, body_part_1, body_part_2|
  email = find_email(subject)
  email.should_not be_nil
  email.body.should =~ Regexp.new(body_part_1)
  email.body.should =~ Regexp.new(body_part_2)
end
