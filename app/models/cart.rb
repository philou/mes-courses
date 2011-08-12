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

  def forward_to(session, order)
    session.empty_the_cart
    order.missing_items_names = ""

    lines.each_with_index do |line, line_index|
      begin
        line.forward_to(session)
      rescue UnavailableItemError
        order.missing_items_names = order.missing_items_names + line.name + "\n"
      end
      order.forwarded_cart_lines_count = line_index + 1
      order.save!
    end

    order.remote_store_order_url = session.logout_url
  end
end
