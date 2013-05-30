# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'uri'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  Utils = MesCourses::Utils
  Carts = MesCourses::Stores::Carts
  Items = MesCourses::Stores::Items
  Imports = MesCourses::Stores::Imports

  attr_accessible :url, :sponsored_url, :expected_items

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
    cart_api.logout_url
  end

  def login_form_html(credentials)
    cart_api.login_form_html(credentials.login, credentials.password)
  end

  # Opens a remote cart session to the remote store
  def with_session(login, password)
    cart_api.login(login, password).with_logout do |session|
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

  private

  def cart_api
    Carts::Base.for_url(url)
  end

  public  # friend: IncrementalImporter

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
      connection.execute %{DELETE FROM item_categories_items WHERE item_category_id = #{ItemCategory.disabled.id}}
      connection.execute %{INSERT INTO item_categories_items(item_id,item_category_id)
                           SELECT item_id, #{ItemCategory.disabled.id} FROM import_sold_out_items}
    end
  end

  def delete_unused_items
    Item.transaction do
      connection.execute %{CREATE TEMPORARY TABLE unused_items ON COMMIT DROP AS
                           SELECT item_id
                           FROM item_categories_items
                           WHERE item_category_id = #{ItemCategory.disabled.id}
                           AND item_id NOT IN (SELECT item_id FROM dishes_items)
                           AND item_id NOT IN (SELECT item_id FROM cart_lines) }
      connection.execute %{DELETE FROM item_categories_items WHERE item_id IN (SELECT item_id FROM unused_items) }
      connection.execute %{DELETE FROM items WHERE id IN (SELECT item_id FROM unused_items) }
    end
  end

  def delete_unused_item_categories
    while 0 != execute_delete(%{DELETE FROM item_categories
                                WHERE id NOT IN (SELECT item_category_id FROM item_categories_items WHERE item_category_id IS NOT NULL)
                                AND id NOT IN (SELECT parent_id FROM item_categories WHERE parent_id IS NOT NULL)
                                AND parent_id IS NOT NULL })
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
