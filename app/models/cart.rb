# Copyright (C) 2010, 2011 by Philippe Bourgau


# Session cart for a user
class Cart

  def initialize
    @items_to_lines = {}
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

  def forward_to_store(login, password)
    store_api = StoreAPI.login(login, password)

    begin
      store_api.empty_the_cart

      lines.each do |line|
        line.forward_to(store_api)
      end

    ensure
      store_api.logout
    end

  end

end
