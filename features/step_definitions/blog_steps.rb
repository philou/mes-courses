# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

BLOG_ARTICLE_CONTENT = "Des choses très très intéressantes"

Given /^there is a blog article "(.*?)"$/ do |title|
  post = Blogit::Post.new(title: title, body: BLOG_ARTICLE_CONTENT)
  post.blogger = user
  post.save!
end

When /^I post a new blog article "(.*?)"$/ do |title|
  visit path_to('the blog page')
  click_link('Nouvel article')
  within('#new_blog_post') do
    fill_in 'post[title]', with: title
    fill_in 'post[body]', with: BLOG_ARTICLE_CONTENT
    click_button 'Créer un(e) article'
  end
end

When /^I delete the blog article "(.*?)"$/ do |title|
  visit path_to("the blog article \"#{title}\" page")
  click_link('supprimer')
end

Then /^there should be a link to the write a new article$/ do
  page.should have_xpath("//a[@href='/blog/posts/new'][contains(.,'Nouvel article')]")
end

Then /^there should be a blog article "(.*?)"$/ do |title|
  visit path_to('the blog page')
  page.should have_content(title)
end

Then /^there should not be a blog article "(.*?)"$/ do |title|
  visit path_to('the blog page')
  page.should_not have_content(title)
end

Then /^I should see the whole blog sidebar$/ do
  page.should contain_a(blog_sidebar_section("about"))
  page.should contain_a(blog_sidebar_section("tags"))
  page.should contain_a(blog_sidebar_section("subscription"))
  page.should contain_a(blog_sidebar_section("archive"))
end

Then /^I should see the social and navigation article footer$/ do
  # tag links
  # social bar
  # disqus comments
  pending # express the regexp above with the code you wish you had
end
