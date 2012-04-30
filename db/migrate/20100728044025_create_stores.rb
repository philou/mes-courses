# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
