# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau

class Dish < ActiveRecord::Base
  has_and_belongs_to_many :items

  validates_presence_of :name
  validates_uniqueness_of :name

  def disabled?
    items.any? {|item| item.disabled? }
  end
end
