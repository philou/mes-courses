# Copyright (C) 2010 by Philippe Bourgau

# Objects deciding what to do with what the scrapper found in
# the online store's web page.
class IncrementalImporter

  def initialize(store)
    @store = store
  end

  # Methods called by the scrapper when he founds something
  def found_item_type(params)
    @store.found_item_type(params)
  end
  def found_item_sub_type(params)
    @store.found_item_sub_type(params)
  end
  def found_item(params)
    if !@store.knows_item(params)
      @store.found_item(params)
    end

  end

end
