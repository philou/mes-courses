# Copyright (C) 2010 by Philippe Bourgau


# A know dish
class Dish < ActiveRecord::Base
  has_and_belongs_to_many :items
end
