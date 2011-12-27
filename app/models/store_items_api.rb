# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'rubygems'
require 'auchan_direct_store_items_api'

# Objects able to walk a store and discover available items
class StoreItemsAPI

  def self.browse(store_url)
    if store_url == DummyStoreCartAPI.url
      DummyStoreItemsAPI.new_default_store(store_url)
    else
      auchan_direct_store_items_api(store_url)
    end
  end

  # Uri of the main page of the store
  # def uri

  # Attributes of the page
  # def attributes

  # Walkers of the root categories of the store
  # def categories

  # Walkers of the root items in the store
  # def items
end

