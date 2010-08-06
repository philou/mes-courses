# Monkey patches for store objects to speed up and adapt
# catalog import
module StoreSpecHelper

  def when_importing_from(store, params = {})
    if params.include? :skip_links_like
      do_not_follow_online_links_when_importing_from(store, params[:skip_links_like])
    end
    
    if params.include? :squeeze_loops_to
      do_not_follow_more_than_3_similar_links_when_importing_from(store, [:squeeze_loops_to])
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
  def do_not_follow_more_than_3_similar_links_when_importing_from(store, max)
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
    store.max_nodes = 3
  end

end
