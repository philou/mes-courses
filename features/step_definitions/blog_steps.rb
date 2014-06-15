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
  expect(page).to have_xpath("//a[@href='/blog/posts/new'][contains(.,'Nouvel article')]")
end

Then /^there should be a blog article "(.*?)"$/ do |title|
  visit path_to('the blog page')
  expect(page).to have_content(title)
end

Then /^there should not be a blog article "(.*?)"$/ do |title|
  visit path_to('the blog page')
  expect(page).not_to have_content(title)
end

Then /^I should see the whole blog sidebar$/ do
  expect(page).to contain_a(blog_sidebar_section("about"))
  expect(page).to contain_a(blog_sidebar_section("tags"))
  expect(page).to contain_a(blog_sidebar_section("subscription"))
  expect(page).to contain_a(blog_sidebar_section("archive"))
end

Then /^I should see the social and navigation article footer$/ do
  expect(page).to contain_a(blog_post_social_bar)
  expect(page).to contain_a(blog_post_related_posts)
  expect(page).to contain_a(blog_post_disqus_comments)
end
