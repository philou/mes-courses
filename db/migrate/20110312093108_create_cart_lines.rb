# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


class CreateCartLines < ActiveRecord::Migration
  def self.up
    create_table :cart_lines do |t|
      t.integer :quantity, :null => false
      t.integer :item_id, :null => false
      t.integer :cart_id, :null => false

      t.timestamps
   end

    add_index :cart_lines, [:cart_id], :name => "cart_lines_cart_id_index", :unique => false
    add_index :cart_lines, [:cart_id,:item_id], :name => "cart_lines_cart_id_item_id_index", :unique => true
  end

  def self.down
    drop_table :cart_lines
  end
end
