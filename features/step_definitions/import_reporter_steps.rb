# Copyright (C) 2011 by Philippe Bourgau

When /^stats are updated$/ do
  ImportReporter.update_stats_and_report
end

Then /^an email with subject containing "([^"]*)" should be sent to "([^"]*)"$/ do |subject, to|
  emails = ActionMailer::Base.deliveries
  emails.should have(1).entry
  emails[0].to.should == [to]
  emails[0].subject.should =~ Regexp.new(subject)
end
