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


# Objects representing a quantity of a bought item in the cart
class CartLine < ActiveRecord::Base

  attr_accessible :quantity, :item, :cart

  belongs_to :cart
  belongs_to :item

  validates_presence_of :quantity, :item

  def name
    item.long_name
  end

  def price
    quantity * item.price
  end

  def increment_quantity
    self.quantity = quantity + 1
  end

  def forward_to(store_api)
    store_api.add_to_cart(quantity, item)
  end

end
