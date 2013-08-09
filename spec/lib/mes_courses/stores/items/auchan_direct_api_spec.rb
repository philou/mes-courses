# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

when_online "AuchanDirectStoreItemsAPI remote spec" do

  module MesCourses
    module Stores
      module Items

        describe "AuchanDirectAPI", slow: true, remote: true do
          include ApiSpecMacros

          before :all do
            @store = Api.browse("http://www.auchandirect.fr")
          end

          it_should_behave_like_any_store_items_api

          it "should have absolute urls for images" do
            expect(sample_items_attributes.map {|attr| attr[:image]}).to all_do include("auchandirect.fr")
          end

        end
      end
    end
  end
end
