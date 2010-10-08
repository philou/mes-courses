# Copyright (C) 2010 by Philippe Bourgau

# Objects deciding what to do with what the store scrapper found in
# the online store's web page. They get hashes of parameters as input
# and forward record instances to the store.
class IncrementalStore

  def initialize(store)
    @store = store
  end

  # Methods called by the scrapper when he founds something
  def register_item_type(params)
    result = ItemType.new(params)
    @store.register_item_type(result)
    result
  end
  def register_item_sub_type(params)
    result = ItemSubType.new(params)
    @store.register_item_sub_type(result)
    result
  end
  def register_item(params)
    item = @store.known_item(params[:name])
    if item.nil?
      item = Item.new(params)
      @store.register_item(item)
    else
      # TO REMOVE this is a tweak until we'll handle item types and sub types incrementaly,
      params.delete(:item_sub_type)
      if !item.equal_to_attributes?(params)
        item.attributes= params
        @store.register_item(item)
      end
    end
    item
  end

end

