# Copyright (C) 2010, 2011 by Philippe Bourgau

# Hierarchichal category of items,
class ItemCategory < ActiveRecord::Base
  has_many :items
  acts_as_tree :order => "name"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"
end
