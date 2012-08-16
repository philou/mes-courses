# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require 'offline_test_helper'
require_relative 'api_shared_examples'

include OfflineTestHelper

when_online("AuchanDirectApi remote spec") do

  module MesCourses::StoreCart

    class AuchanDirectApi

      def self.valid_login
        "mes.courses.fr.test@gmail.com"
      end
      def self.valid_password
        # gmail password : "mes*courses"
        "mescourses"
      end

    end

    describe AuchanDirectApi, slow: true, remote: true do
      it_should_behave_like "Any Api"

      before(:all) do
        @store_cart_api = AuchanDirectApi
      end
    end
  end
end
