# Copyright (C) 2011 by Philippe Bourgau

require 'rubygems'
require 'spec_helper'
require 'models/store_cart_api_shared_examples'

include OfflineTestHelper

if offline?
  puts yellow "WARNING: skipping StoreCartAPI remote spec because tests are running offline."

else

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
