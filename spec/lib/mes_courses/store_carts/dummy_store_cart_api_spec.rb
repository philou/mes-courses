# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'store_cart_api_shared_examples'
require 'mes_courses/store_carts/dummy_store_cart_api'

module MesCourses
  module StoreCarts

    describe DummyStoreCartAPI do
      it_should_behave_like "Any StoreCartAPI"

      before(:all) do
        @store_cart_api = DummyStoreCartAPI
      end

    end

  end
end
