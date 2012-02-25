# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

# Deletion marker table for items used during incremental import.
# This table is not supposed to be active recorded.
class CreateToDeleteItems < ActiveRecord::Migration
  def self.up
    create_table :to_delete_items, :primary_key => :item_id do |t|
      t.integer :item_id
    end
  end

  def self.down
    drop_table :to_delete_items
  end
end
