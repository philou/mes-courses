# Copyright (C) 2011 by Philippe Bourgau

# A loged in session on the remote store. Manipulates the remote cart, and performs error checking.
class StoreSession
  include WithLogoutMixin

  # Logs in the store account of a user and returns a StoreAPI instance
  def self.login(store_url, login, password)
    StoreSession.new(StoreAPI.login(store_url, login, password))
  end

  # logs out from the store
  def logout
    @store_api.logout
  end

  # total value of the remote cart
  def value_of_the_cart
    @cart_value ||= @store_api.value_of_the_cart
  end

  # url at which a client browser can logout
  def logout_url
    @store_api.logout_url
  end

  # empties the cart of the current user
  def empty_the_cart
    @store_api.empty_the_cart
    @cart_value = 0.0
  end

  # adds items to the cart of the current user
  # Throws UnavailableItemError if the value of the cart did not change
  def set_item_quantity_in_cart(quantity, item)
    return if (quantity == 0)

    old_cart_value = value_of_the_cart
    @store_api.set_item_quantity_in_cart(quantity, item.remote_id)
    new_cart_value = @store_api.value_of_the_cart

    raise UnavailableItemError.new("Item '#{item.name}' is not available") unless new_cart_value != old_cart_value

    @cart_value = new_cart_value
  end

  private

  def initialize(store_api)
    @store_api = store_api
  end

end
