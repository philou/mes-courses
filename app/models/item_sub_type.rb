# Copyright (C) 2010 by Philippe Bourgau

class ItemSubType < ActiveRecord::Base
  has_many :items
  belongs_to :item_type

  validates_presence_of :name, :item_type
  validates_uniqueness_of :name, :scope => "item_type_id"
end
