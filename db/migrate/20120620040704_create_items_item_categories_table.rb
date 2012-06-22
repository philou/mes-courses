# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

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
