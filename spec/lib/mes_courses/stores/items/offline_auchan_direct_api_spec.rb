# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'auchan_direct_api_shared_examples'

module MesCourses::Stores::Items
  describe "OfflineAuchanDirectApi", slow: true do
    include AuchanDirectApiSpecMacros

    before :all do
      @store = Api.browse(AUCHAN_DIRECT_OFFLINE)
    end

    it_should_behave_like_any_auchan_direct_store_items_api

  end
end
