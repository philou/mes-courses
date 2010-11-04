# Copyright (C) 2010 by Philippe Bourgau

class ItemType < ActiveRecord::Base
  has_many :item_sub_types

  validates_presence_of :name
  validates_uniqueness_of :name
end
