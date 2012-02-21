# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'mechanize'
require 'auchan_direct_store_cart_api'

# Objects providing an api like access to third party online stores
class StoreCartAPI
  include WithLogoutMixin

  # factory of store cart api for a given url
  def self.for_url(store_url)
    if store_url == AuchanDirectStoreCartAPI.url
      AuchanDirectStoreCartAPI
    elsif store_url == DummyStoreCartAPI.url
      DummyStoreCartAPI
    else
      raise ArgumentError.new("StoreCartAPI does not handle store at '#{store_url}'")
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
