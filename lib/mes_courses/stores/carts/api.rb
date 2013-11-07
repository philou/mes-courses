# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Stores
    module Carts

      # Objects providing an api like access to third party online stores
      class Api
        include WithLogoutMixin

        # factory of store cart api for a given url
        def self.for_url(store_url)
          if store_url == AuchanDirectApi.url
            AuchanDirectApi
          elsif store_url.include?(DummyApi.url)
            DummyApi
          else
            raise ArgumentError.new("No store api found for store at '#{store_url}'")
          end
        end

        class << self
          alias :login :new
        end

        # main url of the store
        # def self.url
        def url
          self.class.url
        end

        # url at which a client browser can login
        # def self.login_url

        # parameters for a client side login
        # def self.login_parameters(login, password)

        # login and password parameters names
        # def self.login_parameter
        # def self.password_parameter

        # url at which a client browser can logout
        # def self.logout_url

        # logs in to the remote store
        # def initialize(login, password)

        # logs out from the store
        # def logout

        # total value of the remote cart
        # def cart_value

        # empties the cart of the current user
        # def empty_the_cart

        # adds items to the cart of the current user
        # def add_to_cart_cart(quantity, item_remote_id)

      end
    end
  end
end
