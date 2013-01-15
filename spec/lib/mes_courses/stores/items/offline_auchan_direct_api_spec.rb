# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

module MesCourses
  module Stores
    module Items
      describe "OfflineAuchanDirectApi", slow: true do
        include ApiSpecMacros

        before :all do
          auchan_direct_offline = "file://"+File.join(Rails.root,'offline_sites','www.refonte.auchandirect.fr', 'index.html')
          @store = Api.browse(auchan_direct_offline)
        end

        it_should_behave_like_any_store_items_api
      end
    end
  end
end
