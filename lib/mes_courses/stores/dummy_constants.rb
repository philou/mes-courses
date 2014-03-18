# -*- coding: utf-8 -*-
# Copyright (C) 2012, 2013, 2014 by Philippe Bourgau

require 'storexplore/testing/dummy_store_constants'

module MesCourses
  module Stores
    module DummyConstants
      STORE_URL = Auchandirect::ScrAPI::DummyCart.url
      SPONSORED_URL = "#{STORE_URL}/sponsored"
    end
  end
end
