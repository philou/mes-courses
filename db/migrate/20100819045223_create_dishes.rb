# Copyright (C) 2010 by Philippe Bourgau

class CreateDishes < ActiveRecord::Migration
  def self.up
    create_table :dishes do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :dishes
  end
end
