# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class InsertRootItemCategory < ActiveRecord::Migration
  def self.up
    top_categories = ItemCategory.find(:all, :conditions => {:parent_id => nil})
    ItemCategory.create!(:name => ItemCategory::ROOT_NAME, :children => top_categories)
  end

  def self.down
    root_category = ItemCategory.root
    unless root_category.nil?
      root_category.children.each do |category|
        category.parent = nil
        category.save!
      end
      root_category.delete
    end
  end
end
