# Copyright (C) 2011 by Philippe Bourgau

When /^stats are updated$/ do
  ImportReporter.deliver_delta
end

Then /^an email with subject containing "([^"]*)" should be sent to the maintainer$/ do |subject|
  emails = ActionMailer::Base.deliveries
  emails.should have(1).entry
  emails[0].to.should == EmailConstants.recipients
  emails[0].subject.should =~ Regexp.new(subject)
end
