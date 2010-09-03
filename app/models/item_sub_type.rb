# Copyright (C) 2010 by Philippe Bourgau

class ItemSubType < ActiveRecord::Base
  has_many :items
  belongs_to :type, :class_name => ItemType
end
