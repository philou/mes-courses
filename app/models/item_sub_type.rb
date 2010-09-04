# Copyright (C) 2010 by Philippe Bourgau

class ItemSubType < ActiveRecord::Base
  has_many :items
  belongs_to :item_type
end
