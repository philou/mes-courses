# Copyright (C) 2010, 2011 by Philippe Bourgau


# Session cart for a user
class Cart < ActiveRecord::Base

  has_many :lines,
           :class_name => "CartLine",
           :foreign_key => "cart_id",
           :dependent => :destroy,
           :autosave => true

  def empty?
    return lines.empty?
  end

  def add_item(item)
    cart_line = lines.detect {|line| line.item == item }
    if cart_line.nil?
      lines.build(:quantity => 1, :item => item)
   else
      cart_line.increment_quantity
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
      store_api.empty_the_cart

      lines.each do |line|
        line.forward_to(store_api)
      end

      return store_api.logout_url
    end
  end

end
