# Copyright (C) 2011 by Philippe Bourgau

class CreateModelStats < ActiveRecord::Migration

  INDEX_NAME = 'model_name_name_index'

  def self.up
    create_table :model_stats do |t|
      t.string :name, :null => false
      t.integer :count, :null => false

      t.timestamps
    end

    add_index :model_stats, :name, :name => INDEX_NAME, :unique => true
  end

  def self.down
    remove_index :model_stats, :name => INDEX_NAME
    drop_table :model_stats
  end
end
