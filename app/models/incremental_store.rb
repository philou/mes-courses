# Copyright (C) 2010 by Philippe Bourgau

# Objects deciding what to do with what the store scrapper found in
# the online store's web page. They get hashes of parameters as input
# and forward record instances to the store.
class IncrementalStore

  def initialize(store)
    @store = store
  end

  # Methods called by the scrapper to start and stop import
  def starting_import
    @store.mark_existing_items
  end
  def finishing_import
    @store.delete_sold_out_items
  end

  # Methods called by the scrapper when he founds something
  def register_item_type(params)
    result = ItemType.new(params)
    @store.register!(result)
    result
  end
  def register_item_sub_type(params)
    result = ItemSubType.new(params)
    @store.register!(result)
    result
  end
  def register_item(params)
    item = @store.known_item(params[:name])
    if item.nil?
      item = Item.new(params)
      @store.register!(item)
    else
      # TO REMOVE this is a tweak until we'll handle item types and sub types incrementaly,
      params.delete(:item_sub_type)
      if !item.equal_to_attributes?(params)
        item.attributes= params
        @store.register!(item)
      end
    end
    @store.mark_not_sold_out(item)
    item
  end

end

