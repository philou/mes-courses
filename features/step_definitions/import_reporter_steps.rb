# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

def find_maintainance_email(subject)
  emails = ActionMailer::Base.deliveries
  email = emails.find { |email| email.subject =~ Regexp.new(subject) }

  expect(email.to).to eq maintainers_emails

  email
end

Then /^an import report email should be sent to the maintainer$/ do
  email = find_maintainance_email("Import (OK)|(WARNING)")
  expect(email).not_to be_nil, "no import report email was sent"

  expect(email.body).to match(/Root item category: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about root item categories"
  expect(email.body).to match(/Item category: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about item categories"
  expect(email.body).to match(/Item: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about items"
  expect(email.body).to match(/Import took : \d+h \d+m \d+s/), "Import report email has no duration"
end

Then /^a broken dishes report email should be sent to the maintainer with$/ do |details_table|
  email = find_maintainance_email(BrokenDishesReporter::SUBJECT)
  expect(email).not_to be_nil, "no broken dish email was sent"

  details_table.hashes.each do |row|
    row.each do |part, part_content|
      expect(email.body).to match(Regexp.new(part_content)), "broken dish email has no mention of a #{part} : '#{part_content}'"
    end
  end
end
