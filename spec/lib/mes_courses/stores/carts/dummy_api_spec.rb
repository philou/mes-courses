# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013, 2014 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'
require 'storexplore/testing'

module MesCourses
  module Stores
    module Carts

      describe DummyApi do
        it_should_behave_like "Any Api"

        before(:all) do
          store_name = "www.cart-dummy-api-spec.com"

          Storexplore::Testing::DummyStore.wipe_out_store(store_name)
          Storexplore::Testing::DummyStore.open(store_name).generate(3).categories.and(3).categories.and(3).items

          @store_cart_api = DummyApi
          @store_items_url = Storexplore::Testing::DummyStore.uri(store_name)
        end
      end
    end
  end
end
