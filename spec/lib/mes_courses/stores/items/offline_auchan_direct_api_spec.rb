# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

puts yellow "WARNING: Offline auchan direct import tests will not be run until the new site has been downloaded"

# module MesCourses
#   module Stores
#     module Items
#       describe "OfflineAuchanDirectApi", slow: true do
#         include ApiSpecMacros

#         before :all do
#           @store = Api.browse(AUCHAN_DIRECT_OFFLINE)
#         end

#         it_should_behave_like_any_store_items_api

#         it "should not truncate long names of items" do
#           sample_items_attributes.find_all {|item| 20 <= item[:name].length }.should_not be_empty
#         end
#       end
#     end
#   end
# end
