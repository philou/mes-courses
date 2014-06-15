# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau
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


class CreateItemsItemCategoriesTable < ActiveRecord::Migration
  def up
    create_table :item_categories_items, {:id => false} do |t|
      t.integer :item_id, null: false
      t.integer :item_category_id, null: false
    end
    add_index "item_categories_items", ["item_id"], :name => "item_categories_items_item_id_index"
    add_index "item_categories_items", ["item_category_id"], :name => "item_categories_items_item_category_id_index"

    execute "INSERT INTO item_categories_items(item_id, item_category_id) SELECT id, item_category_id FROM items"

    remove_column :items, :item_category_id
  end

  def down
    add_column :items, :item_category_id, :integer

    # This might fail if there are more than one category associated to an item
    execute <<-END_OF_SQL
               UPDATE items
               SET item_category_id = item_categories_items.item_category_id
               FROM item_categories_items
               WHERE item_categories_items.item_id = items.id
               END_OF_SQL

    change_column :items, :item_category_id, :integer, :null => false

    remove_index "item_categories_items", :name => "item_categories_items_item_category_id_index"
    remove_index "item_categories_items", :name => "item_categories_items_item_id_index"
    drop_table :item_categories_items
  end
end
