# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class AddForeignKeysToItemCategoriesItems < ActiveRecord::Migration

  def self.up
    add_foreign_key :item_categories_items, :items
    add_foreign_key :item_categories_items, :item_categories
  end

  def self.down
    remove_foreign_key :item_categories_items, :items
    remove_foreign_key :item_categories_items, :item_categories
  end

end
