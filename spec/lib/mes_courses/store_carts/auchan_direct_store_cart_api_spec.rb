# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'store_cart_api_shared_examples'
require 'offline_test_helper'

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

  describe AuchanDirectStoreCartAPI, slow: true, remote: true do
    it_should_behave_like "Any StoreCartAPI"

    before(:all) do
      @store_cart_api = AuchanDirectStoreCartAPI
    end

  end

end
