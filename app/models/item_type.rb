# Copyright (C) 2010 by Philippe Bourgau

class ItemType < ActiveRecord::Base
  has_many :item_sub_types
end
