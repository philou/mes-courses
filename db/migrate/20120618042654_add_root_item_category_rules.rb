# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class AddRootItemCategoryRules < ActiveRecord::Migration
  def self.up
    root_cat = ItemCategory.root

    execute "CREATE RULE prevent_delete_of_root_item_category AS ON DELETE TO item_categories WHERE old.id = #{root_cat.id} DO INSTEAD NOTHING;"
  end

  def self.down
    execute "DROP RULE prevent_delete_of_root_item_category ON item_categories;"
  end
end
