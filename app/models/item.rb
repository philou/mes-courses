# Copyright (C) 2010 by Philippe Bourgau


# An item for sale
class Item < ActiveRecord::Base
  has_and_belongs_to_many :dishes
  belongs_to :item_sub_type
end
