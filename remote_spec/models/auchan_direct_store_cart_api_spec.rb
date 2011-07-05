# Copyright (C) 2011 by Philippe Bourgau

require 'rubygems'
require 'spec_helper'
require 'models/store_cart_api_shared_examples'
require 'lib/offline_test_helper'

include OfflineTestHelper

when_online("AuchanDirectStoreCartAPI remote spec") do

  class AuchanDirectStoreCartAPI

    def self.valid_login
      "philippe.bourgau@free.fr"
    end
    def self.valid_password
      "NoahRules78"
    end

  end

  describe AuchanDirectStoreCartAPI do
    it_should_behave_like "Any StoreCartAPI"

    before(:all) do
      @store_cart_api = AuchanDirectStoreCartAPI
    end

  end

end
