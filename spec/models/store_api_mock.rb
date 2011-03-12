# Copyright (C) 2011 by Philippe Bourgau


# Logger mock for StoreAPI.
# TODO check for not-a-mock or RR RSpec plugins
#      or make a generic class of this logger
class StoreAPIMock

  attr_reader :store_url, :login, :password, :log

  def initialize(store_url, login, password)
    @log = []
    @store_url = store_url
    @login = login
    @password = password
    @cart_value = 0.0;
  end

  def logout
    @log.push(:logout)
  end

  def empty_the_cart
    @log.push(:empty_the_cart)
    @cart_value = 0.0
  end

  def set_item_quantity_in_cart(quantity, item)
    @log.push(:set_item_quantity_in_cart)
    @cart_value = @cart_value + quantity * item.price
  end

  def logout_url
    @store_url+"/logout"
  end

  def value_of_the_cart
    @cart_value
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
end
