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

      # we could isolate the missing item detection in a store api wrapper
      total = 0.0
      missing_items = []

      lines.each do |line|
        line.forward_to(store_api)

        total = collect_missing_items(total, store_api.value_of_the_cart, line.item, missing_items)
      end

      return { :store_url => store_api.logout_url,
               :missing_items => missing_items}
    end
  end

private
  def collect_missing_items(old_total, new_total, item, missing_items)
    if new_total == old_total
      missing_items.push(item)
    end

    new_total
  end

end
