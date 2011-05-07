# Copyright (C) 2011 by Philippe Bourgau

require 'store_cart_api'

# Logger mock for StoreCartAPI.
class DummyStoreCartAPI < StoreCartAPI

  def self.url
    "http://www.dummy-store.com"
  end
  def self.valid_login
    "valid-login"
  end
  def self.valid_password
    "valid-password"
  end

  attr_reader :url, :login, :password, :log

  def initialize(login = nil, password = nil)
    @log = []
    @url = ""
    @login = ""
    @password = ""
    @unavailable_items = {}
    @content = {}

    if !login.nil? || !password.nil?
      login(DummyStoreCartAPI.url, login, password)
    end

  end

  def login(store_url, login, password)
    if login != DummyStoreCartAPI.valid_login
      raise InvalidStoreAccountError.new
    end

    @log.push(:login)
    @store_url = store_url
    @login = login
    @password = password
  end

  def logout
    @log.push(:logout)
  end

  def empty_the_cart
    @log.push(:empty_the_cart)
    @content = { }
  end

  def set_item_quantity_in_cart(quantity, item_remote_id)
    if available?(item_remote_id)
      @log.push(:set_item_quantity_in_cart)
      # everything is at 1€ in this store (I would have needed the price as argument otherwise)
      @content[item_remote_id] = quantity
    end
  end

  def logout_url
    @store_url+"/logout"
  end

  def value_of_the_cart
    @content.values.inject(0.0) {|x,y| x+y}
  end

  def add_unavailable_item(item_remote_id)
    @unavailable_items[item_remote_id] = true
  end
  def available?(item_remote_id)
    !@unavailable_items[item_remote_id]
  end
end

