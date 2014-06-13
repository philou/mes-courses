# -*- encoding: utf-8 -*-
# Copyright (C) 2014 by Philippe Bourgau

class CreateItemTypes < ActiveRecord::Migration
  def self.up
    create_table :item_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :item_types
  end
end
