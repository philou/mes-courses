# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

module MesCourses
  module Stores
    module Items

      module AuchanDirectApiSpecMacros
        include ApiSpecMacros

        def self.included(base)
          base.send :extend, ClassMethods
        end

        module ClassMethods
          include ApiSpecMacros::ClassMethods

          def it_should_behave_like_any_auchan_direct_store_items_api

            it_should_behave_like_any_store_items_api

            it "should not truncate long names of items" do
              sample_items_attributes.find_all {|item| 20 <= item[:name].length }.should_not be_empty
            end
          end
        end
      end
    end
  end
end
