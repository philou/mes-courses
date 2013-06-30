# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'
require_relative 'client_api_shared_examples'

when_online("AuchanDirectApi remote spec") do

  module MesCourses
    module Stores
      module Carts

        module AuchanDirectApiCredentials
          def valid_login
            "mes.courses.fr.test@gmail.com"
          end
          def valid_password
            # gmail password : "mes*courses"
            "mescourses"
          end
        end
        # force autoload of AuchanDirectApi
        AuchanDirectApi.send(:extend, AuchanDirectApiCredentials)

        describe AuchanDirectApi, slow: true, remote: true do
          it_should_behave_like "Any Api"
          it_should_behave_like "Any Client Api", "Identifiez-vous"

          before(:all) do
            @store_cart_api = AuchanDirectApi
            @store_items_url = AuchanDirectApi.url
          end

        end
      end
    end
  end
end

