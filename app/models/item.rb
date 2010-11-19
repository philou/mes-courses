# Copyright (C) 2010 by Philippe Bourgau

# An item for sale
class Item < ActiveRecord::Base
  has_and_belongs_to_many :dishes
  belongs_to :item_category

  validates_presence_of :name, :item_category, :price
  validates_uniqueness_of :name, :scope => "item_category_id"
end
