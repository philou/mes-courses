# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Carts

      describe Base do

        before :each do
          capture_result_from(DummyApi, :login, into: :dummy_api)
          @store_cart = Base.for_url(DummyConstants::STORE_URL)
        end

        it "should create a session wrapper on a loged in cart api" do
          @store_cart.login(DummyApi.valid_login, DummyApi.valid_password).should be_instance_of(Session)

          expect(@dummy_api.login).to eq(DummyApi.valid_login)
          expect(@dummy_api.password).to eq(DummyApi.valid_password)
        end

        it "should know the logout_url of the api" do
          expect(@store_cart.logout_url).to eq(DummyApi.logout_url)
        end

        it "should know the client login url of the api" do
          expect(@store_cart.login_url).to eq(DummyApi.login_url)
        end

        it "should know the client login parameters of the api" do
          expect(@store_cart.login_parameters(DummyApi.valid_login, DummyApi.valid_password)).to eq(DummyApi.login_parameters(DummyApi.valid_login, DummyApi.valid_password))
        end
      end
    end
  end
end
