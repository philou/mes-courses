# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013, 2014 by Philippe Bourgau

require 'spec_helper'

when_online "AuchanDirectStoreItemsAPI remote spec" do

  module MesCourses
    module Stores
      module Items

        describe "AuchanDirectAPI", slow: true, remote: true do
          include_context "a scrapped store"
          it_should_behave_like "an API"

          def generate_store
            Api.browse("http://www.auchandirect.fr")
          end

          it "should have absolute urls for images" do
            expect(sample_items_attributes.map {|attr| attr[:image]}).to all_ {include("auchandirect.fr")}
          end

        end
      end
    end
  end
end
