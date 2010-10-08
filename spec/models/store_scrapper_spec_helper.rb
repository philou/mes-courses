# Copyright (C) 2010 by Philippe Bourgau

# Monkey patches for store scrapper objects to speed up and adapt
# catalog import
module StoreScrapperSpecHelper

  def when_importing_from(store, params = {})
    if params.include? :skip_links_like
      do_not_follow_online_links_when_importing_from(store, params[:skip_links_like])
    end

    if params.include? :squeeze_loops_to
      do_not_follow_more_than_n_similar_links_when_importing_from(store, params[:squeeze_loops_to])
    end

    if params.include? :increase_price_by
      increase_price_when_importing_from(store, params[:increase_price_by])
    end

  end

  # When digging in the site, don't skip some links
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

  # When digging a website for items, increase the found items price
  # Can be used to simulate change in the web site
  def increase_price_when_importing_from(store, increment)
    class <<store
      attr_accessor :price_increment
      def enrich_item(params)
        result = params.clone
        result[:price] += price_increment
        result
      end
    end
    store.price_increment = increment
  end

end
