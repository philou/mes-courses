# Copyright (C) 2014 by Philippe Bourgau
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



#!/usr/bin/ruby

require 'rubygems'
require 'mechanize'

agent = Mechanize.new
mainPage = agent.get('file:///home/philou/Code/Startup/Spikes/www.auchandirect.fr/frontoffice/index.html')

mainPage.search('#carroussel > div a').each do |link|
  puts link.content
end

# check in mechanize page code to know how to requests another way
link = mainPage.link_with(:text => "Charcuterie")
puts link.text
puts agent.current_page.title

link.click
puts agent.current_page.title
puts agent.current_page
