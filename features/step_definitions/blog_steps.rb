# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

Then /^there should be a link to the write a new article$/ do
  page.should have_xpath("//a[@href='/blog/posts/new'][contains(.,'Nouvel article')]")
end

When /^I post a new blog article "(.*?)" with content$/ do |title, content|
  visit path_to('the blog page')
  click_link('Nouvel article')
  within('#new_blog_post') do
    fill_in 'post[title]', with: title
    fill_in 'post[body]', with: content
    click_button 'Créer un(e) article'
  end
end

Then /^there should be a blog article "(.*?)"$/ do |title|
  visit path_to('the blog page')
  page.should have_content(title)
end

