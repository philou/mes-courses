# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013, 2014 by Philippe Bourgau

module MesCourses
  module Stores
    module Carts

      # Objects providing an api like access to third party online stores
      class BaseApi

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
