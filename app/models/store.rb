# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'store_importer'
require 'incremental_store'
require 'visited_url'
require 'uri'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  validates_presence_of :url
  validates_uniqueness_of :url

  def self.import_retrier_options
    { :max_retries => 5, :ignored_exceptions => [StoreItemsBrowsingError], :sleep_delay => 3, :wrap_result => [:categories, :items] }
  end

  # import all stores, or the one specified with url
  def self.import(url = nil)
    ModelStat::update!
    start_time = now

    begin
      stores = stores_to_import(url)
      Rails.logger.info "Importing #{stores.length.to_s} stores"
      stores.each do |store|
        Rails.logger.info "Importing items from #{store.url}"
        store.import
        Rails.logger.info "Done"
      end
    rescue Exception => e
      Rails.logger.fatal "Import unexpectedly stoped with exception #{e.inspect}"
      raise
    end

    ImportReporter.deliver_delta(now - start_time, Store.maximum(:expected_items))
  end

  # short name for the store
  def name
    URI.parse(url).host
  end

  # Opens a remote cart session to the remote store
  def with_session(login, password)
    StoreCartSession.login(url, login, password).with_logout do |session|
      return yield session
    end
  end

  # Imports the items sold from the online store to our db
  def import
    importer = StoreImporter.new
    browser = Retrier.new(StoreItemsAPI.browse(url), Store.import_retrier_options)
    incremental_store = IncrementalStore.new(self)
    importer.import(browser, incremental_store)
  end

  # friend: IncrementalImporter

  def known_item_category(name)
    ItemCategory.find_by_name(name)
  end
  def known_item(remote_id)
    Item.find_by_remote_id(remote_id)
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
    execute_delete("DELETE FROM to_delete_items where item_id = #{item.id}")
  end

  def find_sold_out_items
    Item.find(:all, :conditions => ["id IN (SELECT item_id FROM to_delete_items)"])
  end

  # Delete all marked items
  def delete_sold_out_items
    result = execute_delete("DELETE FROM items WHERE id IN (SELECT item_id FROM to_delete_items)")
    remove_all_marks
    result
  end
  # Cleans up useless item categories
  def delete_empty_item_categories
    execute_delete(%{DELETE FROM item_categories
                     WHERE id NOT IN (SELECT item_category_id FROM items WHERE item_category_id IS NOT NULL)
                     AND id NOT IN (SELECT parent_id FROM item_categories WHERE parent_id IS NOT NULL)
                    })
  end

  def execute_delete(statement)
    result = result_size connection.execute(statement)
    logger.debug "Delete statement '#{statement}' removed #{result} rows"
    result
  end
  def result_size(sql_result)
    case ActiveRecord::Base.connection.adapter_name
    when 'PostgreSQL'
      sql_result.cmd_tuples
    else
      sql_result.size
    end

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
  # Time.now synonym, used for mocking
  def self.now
    Time.now
  end

  # array of stores to import, according to the 'url' environment variable
  def self.stores_to_import(url = nil)
    if url.nil?
      Store.find(:all)
    else
      [Store.find_or_create_by_url(url)]
    end
  end

  def remove_all_marks
    execute_delete("DELETE FROM to_delete_items")
  end

end
