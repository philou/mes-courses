# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

class AddItemSubTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :item_sub_type_id, :integer
  end

  def self.down
    remove_column :items, :item_sub_type_id
  end
end
