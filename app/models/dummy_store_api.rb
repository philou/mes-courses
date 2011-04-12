# Copyright (C) 2011 by Philippe Bourgau

require 'store_api'

# Logger mock for StoreAPI.
class DummyStoreAPI < StoreAPI

  def self.url
    "http://www.dummy-store.com"
  end

  attr_reader :store_url, :login, :password, :log

  def initialize
    @log = []
    @store_url = ""
    @login = ""
    @password = ""
    @cart_value = 0.0
    @unavailable_items = {}
  end

  def login(store_url, login, password)
    if login != StoreAPI.valid_login
      raise InvalidStoreAccountError.new
    end

    @log.push(:login)
    @store_url = store_url
    @login = login
    @password = password
    @cart_value = 0.0
  end

  def logout
    @log.push(:logout)
  end

  def empty_the_cart
    @log.push(:empty_the_cart)
    @cart_value = 0.0
  end

  def set_item_quantity_in_cart(quantity, item)
    if available?(item)
      @log.push(:set_item_quantity_in_cart)
      @cart_value = @cart_value + quantity * item.price
    end
  end

  def logout_url
    @store_url+"/logout"
  end

  def value_of_the_cart
    @cart_value
  end

  def add_unavailable_item(item)
    @unavailable_items[item] = true
  end
  def available?(item)
    !@unavailable_items[item]
  end
end


# Testing constants added to the StoreAPI class
class StoreAPI
  def self.valid_login
    "valid-login"
  end
  def self.valid_password
    "valid-password"
  end
  def self.invalid_login
    "in" + valid_login
  end
  def self.invalid_password
    "in" + valid_password
  end
end
