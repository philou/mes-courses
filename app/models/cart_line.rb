# Copyright (C) 2010, 2011 by Philippe Bourgau

# Objects representing a quantity of a bought item in the cart
class CartLine < ActiveRecord::Base

  belongs_to :cart
  belongs_to :item

  validates_presence_of :quantity, :item

  def name
    item.name
  end

  def price
    quantity * item.price
  end

  def increment_quantity
    self.quantity = quantity + 1
  end

  def forward_to(store_api)
    store_api.set_item_quantity_in_cart quantity, item
  end

end
