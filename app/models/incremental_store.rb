# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'lib/attributes_comparison'

# Objects deciding what to do with what the store importer found in
# the online store's web page. They get hashes of parameters as input
# and forward record instances to the store.
class IncrementalStore

  def initialize(store)
    @store = store
  end

  # Methods called by the importer to start and stop import
  def starting_import
    @store.mark_existing_items
  end
  def finishing_import
    handle_broken_dishes()

    @store.delete_sold_out_items
    delete_empty_item_categories
    @store.delete_visited_urls
  end

  # Methods called by the importer when he founds something
  def register_item_category(params)
    if params[:parent].nil?
      params = params.merge(:parent => ItemCategory.root)
    end
    existing_item_category = @store.known_item_category(params[:name])
    register_item_class(ItemCategory, existing_item_category, params)
  end
  def register_item(params)
    existing_item = @store.known_item(params[:remote_id])
    item = register_item_class(Item, existing_item, params)
    @store.mark_not_sold_out(item)
    item
  end

  # Methods called by the importer to notify that he visited an url
  def last_import_finished?
    !@store.are_there_visited_urls?
  end
  def already_visited_url?(url)
    @store.already_visited_url?(url)
  end
  def register_visited_url(url)
    @store.register_visited_url(url)
  end

  private
  def register_item_class(model, record, params)
    if is_new?(record)
      record = model.new(params)
      @store.register!(record)

    elsif is_updated?(record, params)
      record.attributes= params
      @store.register!(record)

    end
    record
  end
  def is_new?(record)
    record.nil?
  end
  def is_updated?(record,params)
    !record.equal_to_attributes?(params)
  end

  def delete_empty_item_categories
    items_to_delete = 1
    while 0 < items_to_delete
      items_to_delete = @store.delete_empty_item_categories
    end
  end

  def handle_broken_dishes()
    sold_out_items = @store.find_sold_out_items
    dish_breaking_items = sold_out_items.reject { |item| item.dishes.empty? }
    BrokenDishesReporter.deliver_email dish_breaking_items unless dish_breaking_items.empty?

    dish_breaking_items.each do |item|
      item.dishes.each do |dish|
        dish.items.delete(item)
        dish.save!
      end
    end
  end
end

