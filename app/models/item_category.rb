# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

# Hierarchichal category of items,
class ItemCategory < ActiveRecord::Base
  has_many :items
  acts_as_tree :order => "name"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"

  ROOT_NAME = "<INTERNAL ROOT>"

  def self.root
    find_by_name(ROOT_NAME)
  end

  def root?
    name == ROOT_NAME
  end

  DISABLED_NAME = "<INTERNAL DISABLED>"

  def self.disabled
    find_by_name(DISABLED_NAME)
  end

  def disabled?
    name == DISABLED_NAME
  end

end
