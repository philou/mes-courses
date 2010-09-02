# Copyright (C) 2010 by Philippe Bourgau

# Monkey patches for store objects to speed up and adapt
# catalog import
module StoreSpecHelper

  def when_importing_from(store, params = {})
    if params.include? :skip_links_like
      do_not_follow_online_links_when_importing_from(store, params[:skip_links_like])
    end
    
    if params.include? :squeeze_loops_to
      do_not_follow_more_than_n_similar_links_when_importing_from(store, params[:squeeze_loops_to])
    end

    if params.include? :do_not_save_but_collect_items_in
      do_not_save_but_collect_items_to_db_when_importing_from(store, params[:do_not_save_but_collect_items_in])
    end
      
  end

  # Only work offline.
  def do_not_follow_online_links_when_importing_from(store, regex)
    class <<store
      attr_accessor :skipped_links_regex
      def skip_link?(uri)
        uri =~ skipped_links_regex
      end
    end
    store.skipped_links_regex= regex
  end

  # When digging in the site, don't follow more than 3 items 
  # selected through the same selector.
  def do_not_follow_more_than_n_similar_links_when_importing_from(store, max)
    class <<store
      attr_accessor :max_nodes
      def each_node(collection)
        i = 0
        collection.each do |item|
          if max_nodes <= i
            return
          else
            yield item
          end
          i = i+1
        end
      end
    end
    store.max_nodes = max
  end

  # When digging in the site, don't save items to the db, but store them 
  # in a collector.
  def do_not_save_but_collect_items_to_db_when_importing_from(store, collector)
    class <<store
      attr_accessor :items_collector
      def found_item(params)
        items_collector.push(Item.new(params))
      end
    end
    store.items_collector = collector
  end

end
