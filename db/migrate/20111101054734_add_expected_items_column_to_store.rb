# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class AddExpectedItemsColumnToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :expected_items, :integer, :default => 0, :null => false

    execute "UPDATE stores SET expected_items = 7000 WHERE url = 'http://www.auchandirect.fr'"
  end

  def self.down
    remove_column :stores, :expected_items
  end
end
