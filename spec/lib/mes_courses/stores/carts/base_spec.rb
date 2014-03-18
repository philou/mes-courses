# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Carts

      describe Base do

        before :each do
          @dummy_api_class = Auchandirect::ScrAPI::DummyCart

          capture_result_from(@dummy_api_class, :login, into: :dummy_api)
          @store_cart = Base.for_url(DummyConstants::STORE_URL)
        end

        it "should create a session wrapper on a loged in cart api" do
          expect(@store_cart.login(@dummy_api_class.valid_email, @dummy_api_class.valid_password)).to be_instance_of(Session)

          expect(@dummy_api.login).to eq(@dummy_api_class.valid_email)
          expect(@dummy_api.password).to eq(@dummy_api_class.valid_password)
        end

        it "should know the logout_url of the api" do
          expect(@store_cart.logout_url).to eq(@dummy_api_class.logout_url)
        end

        it "should know the client login url of the api" do
          expect(@store_cart.login_url).to eq(@dummy_api_class.login_url)
        end

        it "should know the client login parameters of the api" do
          expect(@store_cart.login_parameters(@dummy_api_class.valid_email, @dummy_api_class.valid_password)).to eq(@dummy_api_class.login_parameters(@dummy_api_class.valid_email, @dummy_api_class.valid_password))
        end
      end
    end
  end
end
