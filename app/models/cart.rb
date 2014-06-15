# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


# Session cart for a user
class Cart < ActiveRecord::Base

  has_many :lines,
           :class_name => "CartLine",
           :foreign_key => "cart_id",
           :dependent => :destroy,
           :autosave => true

  has_and_belongs_to_many :dishes

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

    dishes.push(dish)
  end

  def empty
    lines.clear
    dishes.clear
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

    lines.each_with_index do |line, line_index|
      begin
        line.forward_to(session)
      rescue MesCourses::Stores::Carts::UnavailableItemError
        order.add_missing_cart_line(line)
      end
      order.notify_forwarded_cart_line
      order.save!
    end
  end
end
