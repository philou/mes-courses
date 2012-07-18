# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class AddForeignKeyFromCartLinesToItems < ActiveRecord::Migration

  def self.up
    remove_index "cart_lines", name: "cart_lines_cart_id_item_id_index"

    change_column :items, :price, :decimal, null: true
    change_column :items, :remote_id, :integer, null: true

    execute "INSERT INTO items (name, tokens, created_at, updated_at) VALUES ('#{Constants::LOST_ITEM_NAME}', '', now(), now())"

    execute %{INSERT INTO item_categories_items (item_id, item_category_id)
              SELECT i.id, ic.id
              FROM items i, item_categories ic
              WHERE i.name = '#{Constants::LOST_ITEM_NAME}'
              AND ic.name = '#{Constants::DISABLED_ITEM_CATEGORY_NAME}'}

    execute %{UPDATE cart_lines set item_id = (SELECT id FROM items WHERE name = '#{Constants::LOST_ITEM_NAME}')
              WHERE item_id NOT IN (SELECT id FROM items)}

    add_foreign_key :cart_lines, :items
  end

  def self.down
    remove_foreign_key :cart_lines, :items

    execute <<-END_OF_SQL
               DELETE FROM item_categories_items iic
               USING items i, item_categories ic
               WHERE iic.item_id = i.id AND i.name = '#{Constants::LOST_ITEM_NAME}'
               AND iic.item_category_id = ic.id AND ic.name = '#{Constants::DISABLED_ITEM_CATEGORY_NAME}'
               END_OF_SQL

    execute "DELETE FROM items WHERE name = '#{Constants::LOST_ITEM_NAME}'"

    change_column :items, :price, :decimal, null: false
    change_column :items, :remote_id, :integer, null: false

    add_index "cart_lines", ["cart_id", "item_id"], :name => "cart_lines_cart_id_item_id_index", :unique => true
  end
end
