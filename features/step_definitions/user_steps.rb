# Copyright (C) 2011 by Philippe Bourgau

def log_in
  @user = User.create!(:email => "email@email.com",
                       :password => "password",
                       :password_confirmation => "password")
  visit path_to("the login page")
  fill_in("user_email", :with => @user.email)
  fill_in("user_password", :with => "password")
  click_button("Connection")
end

Given /^I am logged in$/ do
  log_in
end

Given /^I am not logged in$/ do
  # nop to do
end

When /^I log in$/ do
  log_in
end
