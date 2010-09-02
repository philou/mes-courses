# Copyright (C) 2010 by Philippe Bourgau


# Session cart for a user
class Cart

  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(item)
    stop = true
    @items.push(item)
  end

  def add_dish(dish)
    dish.items.each {|item| add_item(item) }
  end
  
end
