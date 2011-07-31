# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'models/unavailable_item_error'

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

  def empty
    lines.clear
  end

  def total_price
    result = 0
    lines.each do |line|
      result += line.price
    end
    result
  end

  def forward_to(store, login, password)
    store.with_session(login, password) do |session|
      session.empty_the_cart
      missing_items = []

      lines.each do |line|
        begin
          line.forward_to(session)
        rescue UnavailableItemError
          missing_items.push(line.item)
        end
      end

      return { :store_url => session.logout_url,
               :missing_items => missing_items}
    end
  end
end
