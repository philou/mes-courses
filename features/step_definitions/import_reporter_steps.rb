# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau


Then /^an import report email should be sent to the maintainer$/ do
  an_import_report_email_should_be_sent_to_the_maintainer
end

Then /^a broken dishes report email should be sent to the maintainer with$/ do |details_table|
  a_broken_dishes_report_email_should_be_sent_to_the_maintainer_with(details_table)
end
