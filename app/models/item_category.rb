# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

# Hierarchichal category of items,
class ItemCategory < ActiveRecord::Base
  include MesCourses::RailsUtils::SingletonBuilder

  has_and_belongs_to_many :items
  acts_as_tree :order => "name"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"

  singleton(:root, Constants::ROOT_ITEM_CATEGORY_NAME)
  singleton(:disabled, Constants::DISABLED_ITEM_CATEGORY_NAME)
end
