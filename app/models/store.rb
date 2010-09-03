# Copyright (C) 2010 by Philippe Bourgau

# Backend online store of a distributor
class Store < ActiveRecord::Base

  attr_accessor :scrapper

  def initialize(*)
    super
    self.scrapper = Scrapper.new
  end

  # voir si on peut faire des stubs temporaires avec spec mocks plutot que mon monkey patch

  # Imports the items sold from the online store to our db
  def import
    scrapper.import(url,self)
  end

  # Handles a newly dug up item.
  # This method can be overriden for testing purpose
  def found_item(params)
    Item.create!(params)
  end

end
