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


# Replaces both item_types and item_sub_types tables by a unique
# item_categories
class ItemTypesToCategories < ActiveRecord::Migration
  def self.up
    rename_table :item_sub_types, :item_categories
    rename_column :items, :item_sub_type_id, :item_category_id # Don't know if updating index is required ...
    rename_column :item_categories, :item_type_id, :parent_id # Don't know if updating index is required ...
    change_column :item_categories, :parent_id, :integer, :null => true

    execute %{INSERT INTO item_categories (name, created_at, updated_at)
              SELECT name, created_at, updated_at FROM item_types}

    migrate_categories_item_type_ids_to_parent_ids

    drop_table("item_types")
  end

  def self.down
    create_table :item_types do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :item_types, [:name], :name => "item_types_name", :unique => true

    execute %{INSERT INTO item_types (name, created_at, updated_at)
              SELECT name, created_at, updated_at FROM item_categories WHERE parent_id IS NULL}

    rollback_categories_parent_ids_to_item_type_ids

    execute %{DELETE FROM item_categories WHERE parent_id IS NULL}

    change_column :item_categories, :parent_id, :integer, :null => false
    rename_column :item_categories, :parent_id, :item_type_id
    rename_column :items, :item_category_id, :item_sub_type_id
    rename_table :item_categories, :item_sub_types
  end

  private
  def self.migrate_categories_item_type_ids_to_parent_ids
    execute(%{SELECT cat.id AS new, typ.id AS old FROM item_categories cat, item_types typ
              WHERE cat.name = typ.name AND cat.parent_id is null}).each do |row|
      old = row["old"]
      new = row["new"]
      execute "UPDATE item_categories set parent_id = #{new} where parent_id = #{old}"
    end
  end

  def self.rollback_categories_parent_ids_to_item_type_ids
    execute(%{SELECT cat.id AS new, typ.id AS old FROM item_categories cat, item_types typ
              WHERE cat.name = typ.name AND cat.parent_id is null}).each do |row|
      old = row["old"]
      new = row["new"]
      execute "UPDATE item_categories set parent_id = #{old} where parent_id = #{new}"
    end
  end
end
