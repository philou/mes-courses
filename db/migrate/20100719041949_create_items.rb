# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
