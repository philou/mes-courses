# Copyright (C) 2010 by Philippe Bourgau

require 'scrapper'
require 'incremental_importer'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  attr_accessor :scrapper

  def initialize(*)
    super
    self.scrapper = Scrapper.new
  end

  # Imports the items sold from the online store to our db
  def import
    scrapper.import(url,IncrementalImporter.new(self))
  end

  # Methods called by the scrapper when he founds something
  def found_item_type(params)
    ItemType.create!(params)
  end
  def found_item_sub_type(params)
    ItemSubType.create!(params)
  end
  def found_item(params)
    Item.create!(params)
  end
  def knows_item(params)
    !Item.find_by_name(params[:name]).nil?
  end

end
