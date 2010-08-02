# Monkey patches for store objects to speed up and adapt
# catalog import
module StoreSpecHelper

  # Only work offline.
  def do_not_follow_online_links_when_importing_from(store)
    def store.skip_link?(uri)
      uri =~ /^http:\/\//
    end
  end

  # When digging in the site, don't follow more than 3 items 
  # selected through the same selector.
  def do_not_follow_more_than_3_similar_links_when_importing_from(store)
    def store.each_node(collection)
      i = 0
      collection.each do |item|
        if 3 <= i
          return
        else
          yield item
        end
        i = i+1
      end
    end
  end

end
