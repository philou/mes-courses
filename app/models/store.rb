# Copyright (C) 2010 by Philippe Bourgau

require 'store_scrapper'
require 'incremental_store'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  attr_accessor :scrapper

  def initialize(*)
    super
    self.scrapper = StoreScrapper.new
  end

  # Imports the items sold from the online store to our db
  def import
    scrapper.import(url,IncrementalStore.new(self))
  end

  # Methods called by the scrapper when he founds something
  def register_item_type(item_type)
    item_type.save!
  end
  def register_item_sub_type(item_sub_type)
    item_sub_type.save!
  end
  def register_item(item)
    item.save!
  end
  def known_item(name)
    Item.find_by_name(name)
  end

end
