# Copyright (C) 2010 by Philippe Bourgau

require 'store_scrapper'
require 'incremental_store'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  validates_presence_of :url
  validates_uniqueness_of :url

  # Imports the items sold from the online store to our db
  # Options can be passed in, such as a custom :scrapping_strategy
  def import(options={})
    scrapper = StoreScrapper.new(options)
    scrapper.import(url,IncrementalStore.new(self))
  end

  # friend: IncrementalImporter

  # Known record, by type and name.
  def known(model, name)
    model.find_by_name(name)
  end
  # Registers something to be saved in the store
  def register!(record)
    record.save!
  end

  # Marks all existing items for deletion
  def mark_existing_items
    remove_all_marks
    connection.execute("INSERT INTO to_delete_items SELECT id from items")
  end

  # Removes the deletion mark on an item
  def mark_not_sold_out(item)
    connection.execute("DELETE FROM to_delete_items where item_id = #{item.id}")
  end

  # Delete all marked items
  def delete_sold_out_items
    connection.execute("DELETE FROM items WHERE id IN (SELECT item_id FROM to_delete_items)")
    remove_all_marks
  end
  # Cleans up useless item sub types
  def delete_empty_item_sub_types
    connection.execute("DELETE FROM item_sub_types WHERE id NOT IN (SELECT item_sub_type_id FROM items)")
  end
  # Cleans up useless item types
  def delete_empty_item_types
    connection.execute("DELETE FROM item_types WHERE id NOT IN (SELECT item_type_id FROM item_sub_types)")
  end

  # Are there already visited urls from a previous import ?
  def are_there_visited_urls?
    0 < VisitedUrl.count
  end
  # Was url already visited during a previous import ?
  def already_visited_url?(url)
    !VisitedUrl.find_by_url(url).nil?
  end
  # Stores a visited url to be able to resume
  def register_visited_url(url)
    VisitedUrl.create!(:url => url)
  end
  # Deletes visited urls, so the next import can restart from the begining
  def delete_visited_urls
    VisitedUrl.delete_all
  end

  private
  def remove_all_marks
    connection.execute("DELETE FROM to_delete_items")
  end

end
