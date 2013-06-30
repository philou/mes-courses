# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

def find_maintainance_email(subject)
  emails = ActionMailer::Base.deliveries
  email = emails.find { |email| email.subject =~ Regexp.new(subject) }

  email.to.should == maintainers_emails

  email
end

Then /^an import report email should be sent to the maintainer$/ do
  email = find_maintainance_email("Import (OK)|(WARNING)")
  email.should_not be_nil, "no import report email was sent"

  email.body.should match(/Root item category: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about root item categories"
  email.body.should match(/Item category: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about item categories"
  email.body.should match(/Item: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about items"
  email.body.should match(/Import took : \d+h \d+m \d+s/), "Import report email has no duration"
end

Then /^a broken dishes report email should be sent to the maintainer with$/ do |details_table|
  email = find_maintainance_email(BrokenDishesReporter::SUBJECT)
  email.should_not be_nil, "no broken dish email was sent"

  details_table.hashes.each do |row|
    row.each do |part, part_content|
      email.body.should match(Regexp.new(part_content)), "broken dish email has no mention of a #{part} : '#{part_content}'"
    end
  end
end
