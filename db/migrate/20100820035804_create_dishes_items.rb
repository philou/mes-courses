# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

class CreateDishesItems < ActiveRecord::Migration
  def self.up
    create_table :dishes_items, {:id => false} do |t|
      t.integer :dish_id
      t.integer :item_id
    end
  end

  def self.down
    drop_table :dishes_items
  end
end
