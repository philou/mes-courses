# Copyright (C) 2010 by Philippe Bourgau

# Hierarchichal category of items,
class ItemCategory < ActiveRecord::Base
  has_many :items

  # replace with acts_as_tree plugin
  belongs_to :parent,
             :class_name => "ItemCategory",
             :foreign_key => "parent_id"
  has_many :children,
           :class_name => "ItemCategory",
           :foreign_key => "parent_id",
           :order => "name",
           :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"
end
