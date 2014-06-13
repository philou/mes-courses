# Copyright (C) 2014 by Philippe Bourgau


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
