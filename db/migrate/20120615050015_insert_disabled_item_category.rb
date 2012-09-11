# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class InsertDisabledItemCategory < ActiveRecord::Migration

  class ItemCategory < ActiveRecord::Base
  end

  def self.up
    disabled_cat = ItemCategory.create!(:name => Constants::DISABLED_ITEM_CATEGORY_NAME)

    execute "CREATE RULE prevent_delete_of_disabled_item_category AS ON DELETE TO item_categories WHERE old.id = #{disabled_cat.id} DO INSTEAD NOTHING;"
  end

  def self.down
    execute "DROP RULE prevent_delete_of_disabled_item_category ON item_categories;"

    disabled_item_category = ItemCategory.find_by_name(Constants::DISABLED_ITEM_CATEGORY_NAME)
    disabled_item_category.delete unless disabled_item_category.nil?
  end
end
