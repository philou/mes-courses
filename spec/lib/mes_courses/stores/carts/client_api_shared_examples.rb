# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

shared_examples_for "Any Client Api" do |please_login_text|

  before :all do
    @please_login_text = please_login_text
  end

  it "logs in and out through HTTP" do
    @client = Mechanize.new
    expect(logged_in?).to(be_false, "should not be logged in at the begining")

    login
    expect(logged_in?).to(be_true, "should be logged in after submitting the login form")

    logout
    expect(logged_in?).to(be_false, "should he logged out after clicking the logout link")
  end

  private

  def logged_in?
    page = @client.get(@store_cart_api.url)
    !page.body.include?(@please_login_text)
  end

  def login
    params = @store_cart_api.login_parameters(@store_cart_api.valid_email, @store_cart_api.valid_password)
    post_params = params.map {|param| {param[:name] => param[:value]}}.inject &:merge

    @client.post(@store_cart_api.login_url, post_params)
  end

  def logout
    @client.get(@store_cart_api.logout_url)
  end

end
