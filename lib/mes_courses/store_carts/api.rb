# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::StoreCarts

  # Objects providing an api like access to third party online stores
  class Api
    include WithLogoutMixin

    # factory of store cart api for a given url
    def self.for_url(store_url)
      if store_url == AuchanDirectApi.url
        AuchanDirectApi
      elsif store_url == DummyApi.url
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

    # logs in to the remote store
    # def initialize(login, password)

    # logs out from the store
    # def logout

    # url at which a client browser can logout
    # def self.logout_url

    # total value of the remote cart
    # def value_of_the_cart

    # empties the cart of the current user
    # def empty_the_cart

    # adds items to the cart of the current user
    # def set_item_quantity_in_cart(quantity, item_remote_id)

  end
end
