# Copyright (C) 2011 by Philippe Bourgau

class RenameIndexes < ActiveRecord::Migration
  def self.up
    remove_index "dishes", :name => "dishes_name"
    add_index "dishes", ["name"], :name => "dishes_name_index", :unique => true

    remove_index "dishes_items", :name => "dishes_items_dish_id"
    add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id_index"

    remove_index "dishes_items", :name => "dishes_items_item_id"
    add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id_index"

    remove_index "item_categories", :name => "item_sub_types_name_item_type_id"
    add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id_index", :unique => true

    remove_index "stores", :name => "stores_url"
    add_index "stores", ["url"], :name => "stores_url_index", :unique => true

    remove_index "visited_urls", :name => "visited_urls_url"
    add_index "visited_urls", ["url"], :name => "visited_urls_url_index", :unique => true
  end

  def self.down
    remove_index "dishes", :name => "dishes_name_index"
    add_index "dishes", ["name"], :name => "dishes_name", :unique => true

    remove_index "dishes_items", :name => "dishes_items_dish_id_index"
    add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id"

    remove_index "dishes_items", :name => "dishes_items_item_id_index"
    add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id"

    remove_index "item_categories", :name => "item_sub_types_name_item_type_id_index"
    add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id", :unique => true

    remove_index "stores", :name => "stores_url_index"
    add_index "stores", ["url"], :name => "stores_url", :unique => true

    remove_index "visited_urls", :name => "visited_urls_url_index"
    add_index "visited_urls", ["url"], :name => "visited_urls_url", :unique => true
  end

  private
end
