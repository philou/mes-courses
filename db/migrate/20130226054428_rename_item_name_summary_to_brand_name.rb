# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class RenameItemNameSummaryToBrandName < ActiveRecord::Migration
  def up
    rename_column :items, :name, :brand
    rename_column :items, :summary, :name

    execute %{UPDATE items SET name = '#{Constants::LOST_ITEM_NAME}' WHERE brand = '#{Constants::LOST_ITEM_NAME}'}

    change_column :items, :name, :text, null: false
    change_column :items, :brand, :text, null: true

    execute %{UPDATE items SET brand = null WHERE name = '#{Constants::LOST_ITEM_NAME}'}
  end

  def down
    execute %{UPDATE items SET brand = '#{Constants::LOST_ITEM_NAME}' WHERE name = '#{Constants::LOST_ITEM_NAME}'}

    change_column :items, :brand, :text, null: false
    change_column :items, :name, :text, null: true

    execute %{UPDATE items SET name = null WHERE brand = '#{Constants::LOST_ITEM_NAME}'}

    rename_column :items, :name, :summary
    rename_column :items, :brand, :name
  end
end
