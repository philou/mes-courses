# Copyright (C) 2011 by Philippe Bourgau

require 'rubygems'
require 'spec_helper'
require 'models/store_cart_api_shared_examples'
require 'lib/offline_test_helper'

include OfflineTestHelper

when_online("AuchanDirectStoreCartAPI remote spec") do

  class AuchanDirectStoreCartAPI

    def self.valid_login
      "mes.courses.fr.test@gmail.com"
    end
    def self.valid_password
      # gmail password : "mes*courses"
      "mescourses"
    end

  end

  describe AuchanDirectStoreCartAPI do
    it_should_behave_like "Any StoreCartAPI"

    before(:all) do
      @store_cart_api = AuchanDirectStoreCartAPI
    end

  end

end
