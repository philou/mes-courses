# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'
require_relative '../items/real_dummy_generator'

module MesCourses
  module Stores
    module Carts

      describe DummyApi do
        it_should_behave_like "Any Api"

        before(:all) do
          store_name = "www.cart-dummy-api-spec.com"

          Items::RealDummy.wipe_out_store(store_name)
          Items::RealDummy.open(store_name).generate(3).categories.and(3).categories.and(3).items

          @store_cart_api = DummyApi
          @store_items_url = Items::RealDummy.uri(store_name)
        end
      end
    end
  end
end
