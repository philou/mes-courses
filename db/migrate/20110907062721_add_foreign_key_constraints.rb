# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau
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


class AddForeignKeyConstraints < ActiveRecord::Migration

  FOREIGN_KEYS = [[:cart_lines, :carts],
                  [:dishes_items, :dishes],
                  [:dishes_items, :items],
                  [:item_categories, :item_categories, { :column => :parent_id, :dependent => :destroy, :name => :item_categories_parent_id_fk } ],
                  [:items, :item_categories],
                  [:orders, :carts],
                  [:orders, :stores]]

  def self.up
    FOREIGN_KEYS.each do |fk_args|
      add_foreign_key *fk_args
    end
  end

  def self.down
    FOREIGN_KEYS.each do |fk_args|
      table = fk_args[0]
      foreign_keys(table).each do |fk_def|
        remove_foreign_key table, :name => fk_def.options[:name]
      end
    end
  end
end
