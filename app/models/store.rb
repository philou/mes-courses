# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'uri'

# Backend online store of a distributor
class Store < ActiveRecord::Base
  include MesCourses
  include MesCourses::Stores

  validates_presence_of :url
  validates_uniqueness_of :url

  def self.import_retrier_options
    { :max_retries => 5, :ignored_exceptions => [Items::BrowsingError], :sleep_delay => 3, :wrap_result => [:categories, :items] }
  end

  # import all stores, or the one specified with url
  def self.import(url = nil)
    Utils::Timing.duration_of do |timer|
      ModelStat::update!

      begin
        stores = stores_to_import(url)
        Rails.logger.info "Importing #{stores.length.to_s} store(s)"
        stores.each do |store|
          Rails.logger.info "Importing items from #{store.url}"
          store.import
          Rails.logger.info "Done"
        end
      rescue Exception => e
        Rails.logger.fatal "Import unexpectedly stoped with exception #{e.inspect}"
        raise
      end

      ImportReporter.delta(timer.seconds, Store.maximum(:expected_items)).deliver
    end
  end

  # short name for the store
  def name
    URI.parse(url).host
  end

  # url for a client browser to logout of the store
  def logout_url
    Carts::Base.for_url(url).logout_url
  end

  # Opens a remote cart session to the remote store
  def with_session(login, password)
    Carts::Base.for_url(url).login(login, password).with_logout do |session|
      return yield session
    end
  end

  # Imports the items sold from the online store to our db
  def import
    importer = Imports::Base.new
    browser = Utils::Retrier.new(Items::Api.browse(url), Store.import_retrier_options)
    incremental_store = Imports::Incremental.new(self)
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
    connection.execute("INSERT INTO import_sold_out_items SELECT id FROM items")
  end

  # Removes the deletion mark on an item
  def mark_not_sold_out(item)
    execute_delete("DELETE FROM import_sold_out_items WHERE item_id = #{item.id}")
  end

  def find_sold_out_items
    Item.where("id IN (SELECT item_id FROM import_sold_out_items)")
  end

  def disable_sold_out_items
    Item.transaction do
      connection.execute("DELETE FROM item_categories_items WHERE item_category_id = #{ItemCategory.disabled.id}")
      connection.execute <<-END_OF_SQL
                            INSERT INTO item_categories_items(item_id,item_category_id)
                            SELECT item_id, #{ItemCategory.disabled.id} FROM import_sold_out_items
                            END_OF_SQL
    end
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
  # array of stores to import, according to the 'url' environment variable
  def self.stores_to_import(url = nil)
    if url.nil?
      Store.all
    else
      [Store.find_or_create_by_url(url)]
    end
  end

  def remove_all_marks
    execute_delete("DELETE FROM import_sold_out_items")
  end

end
