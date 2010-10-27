# Copyright (C) 2010 by Philippe Bourgau


# Session cart for a user
class Cart

  def initialize
    @items = {}
  end

  def items
    @items.values
  end

  def add_item(item)
    if !@items.include?(item)
      @items[item] = CartItem.new(item)
    else
      @items[item].increment_quantity
    end
  end

  def add_dish(dish)
    dish.items.each do |item|
      add_item(item)
    end
  end

  def total_price
    result = 0
    items.each do |item|
      result += item.price
    end
    result
  end

end
