# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class InsertRootItemCategory < ActiveRecord::Migration

  class ItemCategory < ActiveRecord::Base
    acts_as_tree :order => "name"
    attr_protected nil
  end

  def self.up
    top_categories = ItemCategory.find(:all, :conditions => {:parent_id => nil})
    ItemCategory.create!(:name => Constants::ROOT_ITEM_CATEGORY_NAME, :children => top_categories)
  end

  def self.down
    root_category = ItemCategory.find_by_name(Constants::ROOT_ITEM_CATEGORY_NAME)
    unless root_category.nil?
      root_category.children.each do |category|
        category.parent = nil
        category.save!
      end
      root_category.delete
    end
  end
end
