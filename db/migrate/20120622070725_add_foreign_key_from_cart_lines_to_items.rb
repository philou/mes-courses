# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class AddForeignKeyFromCartLinesToItems < ActiveRecord::Migration

  class Item < ActiveRecord::Base
  end

  def self.up
    change_column :items, :price, :decimal, null: true
    change_column :items, :remote_id, :integer, null: true

    lost_item = Item.create(name: Constants::LOST_ITEM_NAME, tokens: "")

    execute <<-END_OF_SQL
               INSERT INTO item_categories_items (item_id, item_category_id)
               SELECT i.id, ic.id
               FROM items i, item_categories ic
               WHERE i.name = '#{Constants::LOST_ITEM_NAME}'
               AND ic.name = '#{Constants::DISABLED_ITEM_CATEGORY_NAME}'
               END_OF_SQL

    execute <<-END_OF_SQL
               UPDATE cart_lines set item_id = #{lost_item.id}
               WHERE item_id not in (SELECT id FROM items)
               END_OF_SQL

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

    Item.find_by_name(Constants::LOST_ITEM_NAME).delete

    change_column :items, :price, :decimal, null: false
    change_column :items, :remote_id, :integer, null: false
  end
end
