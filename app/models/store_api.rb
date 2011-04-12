# Copyright (C) 2011 by Philippe Bourgau

require 'mechanize'
require 'auchan_direct_store_api'

# Objects providing an api like access to third party online stores
class StoreAPI
  include WithLogoutMixin

  # Logs in the store account of a user and returns a StoreAPI instance
  def self.login(store_url, login, password)
    if store_url == AuchanDirectStoreAPI.url
      AuchanDirectStoreAPI.new(login, password)
    elsif store_url == DummyStoreAPI.url
      result = DummyStoreAPI.new
      result.login(store_url, login, password)
      result
    else
      raise ArgumentError.new("StoreAPI does not handle store at '#{store_url}'")
    end
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
  # def logout_url

  # total value of the remote cart
  # def value_of_the_cart

  # empties the cart of the current user
  # def empty_the_cart

  # adds items to the cart of the current user
  # def set_item_quantity_in_cart(quantity, item)

end
