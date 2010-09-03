# Copyright (C) 2010 by Philippe Bourgau

class AddSubTypeToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :sub_type_id, :integer
  end

  def self.down
    remove_column :items, :sub_type_id
  end
end
