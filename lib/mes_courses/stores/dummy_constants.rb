# -*- coding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

require 'storexplore/testing/dummy_store_constants'

module MesCourses
  module Stores
    module DummyConstants
      STORE_URL = "http://www.#{Storexplore::Testing::DummyStoreConstants::NAME}.com"
      SPONSORED_URL = "#{STORE_URL}/sponsored"
    end
  end
end
