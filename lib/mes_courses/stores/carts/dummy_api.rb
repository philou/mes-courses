# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require_relative "api"

module MesCourses
  module Stores
    module Carts

      # Logger mock api
      class DummyApi < Api

        def self.url
          "http://www.#{DummyConstants::ROOT_DIR_NAME}.com"
        end
        def self.valid_email
          "valid@mail.com"
        end
        def self.valid_password
          "valid-password"
        end

        def self.logout_url
          url+"/logout"
        end
        def self.login_url
          url+"/login"
        end
        def self.login_parameters(login,password)
          {'login' => login, 'password' => password}
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
          if login != DummyApi.valid_email
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

        def add_to_cart(quantity, item)
          if available?(item)
            @log.push(:add_to_cart)
            @content[item] += quantity
          end
        end

        def cart_value
          @content.to_a.inject(0.0) do |amount,id_and_quantity|
            item = id_and_quantity.first
            quantity = id_and_quantity.last

            unit_price = item.hash.abs.to_f/1e7

            amount + quantity * unit_price
          end
        end

        def content
          @content.keys
        end

        def empty?
          @content.empty?
        end

        def containing?(item, quantity)
          @content[item] == quantity
        end

        def add_unavailable_item(item)
          @unavailable_items[item] = true
        end
        def available?(item)
          !@unavailable_items[item]
        end

        def new_session
          Session.new(self)
        end

      end
    end
  end
end
