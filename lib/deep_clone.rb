# Copyright (C) 2010 by Philippe Bourgau

require 'rubygems'
require 'active_record'

# Helper methods to deep clone active record(s)
class ActiveRecord::Base

  # Deep clones the record and all its :belongs_to references. Ids will not be cloned.
  # An extra hash can be passed in to get the collection of all cloned
  # records indexed by their class and #id
  def deep_clone(clones = {})
    result = clone
    clones[self.identity_token] = result
    belongs_to = self.class.reflect_on_all_associations.find_all do |reflection|
      reflection.macro == :belongs_to
    end
    belongs_to.each do |reflection|
      ref_clone = ActiveRecord::Base.deep_clone(send(reflection.name), clones)
      result.send("#{reflection.name}=", ref_clone)
    end
    result
  end

  # Deep clones a list of records and all their :belongs_to references.
  # Records (class, #id) appearing multiple times will be cloned only once:
  # it is the caller's responsability to make sure their state are coherent
  def self.deep_clones(root_records)
    clones = {}
    root_records.each do |record|
      deep_clone(record, clones)
    end
    clones.values
  end

  # Token uniquely identifying this record (until the id is changed).
  # Can be used as a hash key
  def identity_token
    if id.nil?
      { :object_id => object_id }
    else
      { :class => self.class.name, :id => id }
    end
  end

  private

  def self.deep_clone(record, clones)
    if record.nil?
      nil
    else
      record.deep_clone(clones)
    end
  end

end
