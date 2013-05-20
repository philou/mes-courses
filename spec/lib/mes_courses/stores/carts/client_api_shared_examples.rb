# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Carts

      shared_examples_for "Any Client Api" do |please_login_text|

        before :all do
          @please_login_text = please_login_text
        end

        it "logs in and out through HTTP" do
          @client = Mechanize.new
          logged_in?.should(be_false, "should not be logged in at the begining")

          login
          logged_in?.should(be_true, "should be logged in after submitting the login form")

          logout
          logged_in?.should(be_false, "should he logged out after clicking the logout link")
        end

        private

        def logged_in?
          page = @client.get(@store_cart_api.url)
          !page.body.include?(@please_login_text)
        end

        def login
          uri = "http://www.cartapispec.com/#{SecureRandom.hex(5)}.html"
          response = <<-eos
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1

<html><body>#{@store_cart_api.login_form_html}</body></html>
eos
          FakeWeb.register_uri(:get, uri, response: response)

          login_page = @client.get(uri)

          login_form = login_page.forms.first
          login_form['inputLogin'] = @store_cart_api.valid_login
          login_form['inputPwd'] = @store_cart_api.valid_password
          login_form.submit
        end

        def logout
          @client.get(@store_cart_api.logout_url)
        end

      end
    end
  end
end
