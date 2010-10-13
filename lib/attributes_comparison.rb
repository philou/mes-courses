# Copyright (C) 2010 by Philippe Bourgau

require 'rubygems'
require 'active_record'

# Helper methods to compare a record attributes to a hash
class ActiveRecord::Base

  # Compares self's attributes with values in a hash
  def equal_to_attributes?(attributes)
    attributes.all? do |attribute, value|
      self.respond_to?(attribute) && (self.send(attribute) == value)
    end
  end

end
