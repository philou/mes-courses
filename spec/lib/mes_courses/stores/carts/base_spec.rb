# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Carts

      describe Base do

        before :each do
          @store_cart = Base.for_url(DummyConstants::STORE_URL)
          DummyApi.on_result_from(:login) {|api| @dummy_api = api}
        end

        it "should create a session wrapper on a loged in cart api" do
          @store_cart.login(DummyApi.valid_login, DummyApi.valid_password).should be_instance_of(Session)
          @dummy_api.should_not be_nil
        end

        it "should know the logout_url of the api" do
          @store_cart.logout_url.should == DummyApi.logout_url
        end

        it "should know the client login form of the api" do
          @store_cart.login_form_html(DummyApi.valid_login, DummyApi.valid_password).should == DummyApi.login_form_html(DummyApi.valid_login, DummyApi.valid_password)
        end
      end
    end
  end
end
