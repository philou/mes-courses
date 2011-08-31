# Copyright (C) 2011 by Philippe Bourgau

class AddTokensToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :tokens, :string

    Item.find(:all).each do |item|
      item.index
      item.save!
    end

    change_column :items, :tokens, :string, :null => false
  end

  def self.down
    remove_column :items, :tokens
  end
end
