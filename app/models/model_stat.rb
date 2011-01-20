# Copyright (C) 2011 by Philippe Bourgau

# Stats about instances saved in the database
class ModelStat < ActiveRecord::Base

  validates_presence_of :name, :count
  validates_uniqueness_of :name

  # Either finds an existing record with name and updates it, or creates a
  # a new one and saves it
  def self.create_or_update_by_name!(name, attributes = {})
    result = find_or_initialize_by_name(name)
    result.update_attributes!(attributes)
    result
  end

end
