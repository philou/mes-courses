# Copyright (C) 2011 by Philippe Bourgau

class AddForeignKeyConstraints < ActiveRecord::Migration

  FOREIGN_KEYS = [[:cart_lines, :cart_id],
                  [:dishes_items, :dish_id],
                  [:dishes_items, :item_id],
                  [:item_categories, :parent_id, { :references => :item_categories, :keys => :id}],
                  [:items, :item_category_id],
                  [:orders, :cart_id],
                  [:orders, :store_id]]

  def self.up
    FOREIGN_KEYS.each do |fk_def|
      add_foreign_key *fk_def
    end
  end

  def self.down
    remove_foreign_key :to_delete_items, :item_id
    FOREIGN_KEYS.each do |fk_def|
      remove_foreign_key *fk_def
    end
  end
end
