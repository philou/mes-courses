# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require_relative "api"

module MesCourses
  module Stores
    module Carts

      # Logger mock api
      class DummyApi < Api

        def self.url
          "http://www.dummy-store.com"
        end
        def self.valid_login
          "valid-login"
        end
        def self.valid_password
          "valid-password"
        end

        attr_reader :login, :password, :log

        def initialize(login = nil, password = nil)
          @log = []
          @login = ""
          @password = ""
          @unavailable_items = {}
          @content = Hash.new(0)

          if !login.nil? || !password.nil?
            relog(login, password)
          end
        end

        def relog(login, password)
          if login != DummyApi.valid_login
            raise InvalidAccountError.new
          end

          @log.push(:login)
          @login = login
          @password = password
        end

        def logout
          @log.push(:logout)
        end

        def empty_the_cart
          @log.push(:empty_the_cart)
          @content.clear
        end

        def add_to_cart(quantity, item_remote_id)
          if available?(item_remote_id)
            @log.push(:add_to_cart)
            @content[item_remote_id] += (item_remote_id.hash.abs.to_f/1e7)
          end
        end

        def self.logout_url
          url+"/logout"
        end

        def cart_value
          @content.values.inject(0.0) {|x,y| x+y}
        end

        def add_unavailable_item(item_remote_id)
          @unavailable_items[item_remote_id] = true
        end
        def available?(item_remote_id)
          !@unavailable_items[item_remote_id]
        end
      end
    end
  end
end
