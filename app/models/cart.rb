# Copyright (C) 2010, 2011 by Philippe Bourgau


# Session cart for a user
class Cart

  def initialize
    @items_to_lines = {}
  end

  def empty?
    return @items_to_lines.empty?
  end

  def lines
    @items_to_lines.values
  end

  def add_item(item)
    if !@items_to_lines.include?(item)
      @items_to_lines[item] = CartLine.new(item)
    else
      @items_to_lines[item].increment_quantity
    end
  end

  def add_dish(dish)
    dish.items.each do |item|
      add_item(item)
    end
  end

  def total_price
    result = 0
    lines.each do |line|
      result += line.price
    end
    result
  end

  def forward_to(store, login, password)
    StoreAPI.with_login(store.url, login, password) do |store_api|
      Rails.logger.warn("Forwarding an empty cart to '#{store.url}'") if empty?

      store_api.empty_the_cart
      cart_value = store_api.value_of_the_cart
      Rails.logger.error("Failed to initialize the cart on '#{store.url}'") unless cart_value == 0.0

      lines.each do |line|
        line.forward_to(store_api)

        new_cart_value = store_api.value_of_the_cart
        if 0.0 < line.price
          Rails.logger.error("Failed to forward '#{line.name}' to the cart on '#{store.url}'") unless cart_value < new_cart_value
        end
        cart_value = new_cart_value
      end

      return store_api.logout_url
    end
  end

end
