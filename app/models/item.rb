# Copyright (C) 2010 by Philippe Bourgau


# An item for sale
class Item < ActiveRecord::Base
  has_and_belongs_to_many :dishes
  belongs_to :item_sub_type

  # Compares self's attributes with values in a hash
  def equal_to_attributes?(attributes)
    attributes.all? do |attribute, value|
      self.respond_to?(attribute) && (self.send(attribute) == value)
    end
  end

end
