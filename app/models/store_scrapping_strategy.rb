# Copyright (C) 2010 by Philippe Bourgau

# Provides implementation for store scrapping specific elementary actions
# allows overriding to customize the scrapping
class StoreScrappingStrategy

  # Should the link be skipped when walking through the online store
  def skip_link?(uri)
    false
  end

  # 'each' synonym for html nodes
  def each_node(collection)
    collection.each {|item| yield item }
  end

  # Enriched params to be used to create a new item
  def enrich_item(params)
    params
  end

  # Handles an exception thrown by the scrapper (should not programming errors)
  def handle_exception
    # by default, just continue
  end
end
