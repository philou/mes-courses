# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::StoreCarts

  # Providers of Store cart session
  class StoreCart

    # A new provider of store cart sessions for a given url
    def self.for_url(store_url)
      StoreCart.new(StoreCartAPI.for_url(store_url))
    end

    # Logs in the store account of a user and returns a StoreCartSession instance
    def login(login, password)
      StoreCartSession.new(@store_cart_api_factory.login(login, password))
    end

    # url for a client browser to log off the store
    def logout_url
      @store_cart_api_factory.logout_url
    end

    private
    def initialize(store_cart_api_factory)
      @store_cart_api_factory = store_cart_api_factory
    end
  end

end
