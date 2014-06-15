# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'webrat/core/locators/link_locator'

def path_bar_link_constraint(path_bar_line)
  if path_bar_line =~ /^a link "([^\"]*)" to (.+ page)$/
    text = $1
    page_name = $2
    "[text()='#{text}'][@href='#{path_to(page_name)}']"

  elsif path_bar_line =~ /^"([^\"]*)"$/
    text = $1
    "[text()='#{text}']"

  end
end

Then /^The path bar should be$/ do |path_bar_lines|
  path_bar_lines.lines.each_with_index do |path_bar_line, index|
    expect(page).to have_xpath("//div[@id='path-bar']/a[#{index+1}]#{path_bar_link_constraint(path_bar_line)}")
  end
  expect(page).not_to have_xpath("//div[@id='path-bar']/a[#{path_bar_lines.lines.count+2}]")
end
