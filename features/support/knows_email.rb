# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


module KnowsEmail
  def an_email_must_have_been_sent(subject, receiver, body)
    expect(all_emails).to have_any_that {and_(deliver_to(receiver),
                                              have_subject(subject),
                                              have_body_text(body))}
  end

  def no_emails_should_have_been_sent_to(receiver)
    expect(mailbox_for(receiver)).to be_empty
  end

  def an_import_report_email_should_be_sent_to_the_maintainer
    email = find_maintainance_email("Import (OK)|(WARNING)")
    expect(email).not_to be_nil, "no import report email was sent"

    expect(email.body).to match(/Root item category: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about root item categories"
    expect(email.body).to match(/Item category: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about item categories"
    expect(email.body).to match(/Item: \d+ -> \d+ [+\-]\d+/), "import report email has no statistics about items"
    expect(email.body).to match(/Import took : \d+h \d+m \d+s/), "Import report email has no duration"
  end

  def a_broken_dishes_report_email_should_be_sent_to_the_maintainer_with(details_table)
    email = find_maintainance_email(BrokenDishesReporter::SUBJECT)
    expect(email).not_to be_nil, "no broken dish email was sent"

    details_table.hashes.each do |row|
      row.each do |part, part_content|
        expect(email.body).to match(Regexp.new(part_content)), "broken dish email has no mention of a #{part} : '#{part_content}'"
      end
    end
  end


  private

  def find_maintainance_email(subject)
    email = emails.find { |email| email.subject =~ Regexp.new(subject) }

    expect(email.to).to eq maintainers_emails

    email
  end

  def emails
    ActionMailer::Base.deliveries
  end

end
World(KnowsEmail)
