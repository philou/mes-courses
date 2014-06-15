# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau
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


# Add non null and uniqueness constraints and indexes
class AddDataConstraints < ActiveRecord::Migration

  NON_NULL_COLUMNS = [[:items, :name, :string],
                      [:stores, :url, :string],
                      [:dishes, :name, :string],
                      [:dishes_items, :dish_id, :integer],
                      [:dishes_items, :item_id, :integer],
                      [:item_types, :name, :string],
                      [:item_sub_types, :name, :string],
                      [:item_sub_types, :item_type_id, :integer],
                      [:items, :item_sub_type_id, :integer],
                      [:items, :price, :decimal],
                      [:visited_urls, :url, :string]
                     ]

  INDEXES = [[:stores, [:url], true],
             [:dishes, [:name], true],
             [:dishes_items, [:dish_id], false],
             [:dishes_items, [:item_id], false],
             [:item_types, [:name], true],
             [:item_sub_types, [:name, :item_type_id], true],
             [:items, [:name, :item_sub_type_id], true],
             [:visited_urls, [:url], true]
            ]

  def self.up
    NON_NULL_COLUMNS.each do |table, column, type|
      change_column table, column, type, :null => false
    end

    INDEXES.each do |table, columns, unique|
      add_index table, columns, :name => index_name(table, columns), :unique => unique
    end
  end

  def self.down
    NON_NULL_COLUMNS.each do |column_args|
      change_column *column_args
    end

    INDEXES.each do |table, columns, _unique|
      remove_index table, :name => index_name(table, columns)
    end
  end

  # Generated name for an index
  def self.index_name(table, columns)
    "#{table}_#{columns.join('_')}"
  end

end
