# Copyright (C) 2010 by Philippe Bourgau

# Objects representing a quantity of a bought item in the cart
class CartItem

  def initialize(item)
    @item = item
    @quantity = 1
  end

  def name
    @item.name
  end

  def price
    @quantity * @item.price
  end

  attr_reader :quantity
  def increment_quantity
    @quantity += 1
  end

end
