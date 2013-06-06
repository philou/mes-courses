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
          uri = fake_login_page

          login_page = @client.get(uri)

          login_form = login_page.forms.first
          login_form.submit
        end

        def logout
          @client.get(@store_cart_api.logout_url)
        end

        def fake_login_page
          uri = "http://www.cartapispec.com/#{SecureRandom.hex(5)}.html"
          FakeWeb.register_uri(:get, uri, response: login_response_page)
          uri
        end

        def login_response_page
          response = <<-eos
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1

<html><bod><form action=\"#{@store_cart_api.login_url}\" method=\"post\">
eos
          @store_cart_api.login_parameters(@store_cart_api.valid_login, @store_cart_api.valid_password).each do |name, value|
            response << "<input value=\"#{value}\" name=\"#{name}\" type=\"hidden\"/>"
          end
          response << '<input value="Go log !" type="submit"/></form></body></html>'

          response
        end

      end
    end
  end
end
