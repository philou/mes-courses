# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'
require "mes_courses/stores/items/real_dummy_api"
require_relative "real_dummy_generator"

module MesCourses
  module Stores
    module Items

      describe "RealDummyApi", slow: true do
        include ApiSpecMacros

        it_should_behave_like_any_store_items_api

        before :each do
          RealDummy.wipe_out
          RealDummy.open(store_name = "www.spec-store.com").generate(3).categories.and(3).categories.and(3).items
          @store = Api.browse(RealDummy.uri(store_name))
        end
      end
    end
  end
end
