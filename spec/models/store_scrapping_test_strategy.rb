# Copyright (C) 2010, 2011 by Philippe Bourgau

# maximum fixnum value
def fixnum_max
  2**(0.size * 8 -2) -1
end

# Cusom testing strategy for store scrapping
class StoreScrappingTestStrategy

  # Default accepted options
  def self.default_params
    { :skip_link_regex => /^http:\/\//,      # Regex to match links to be skipped
      :max_loop_nodes => 3,                  # Max count of nodes that can be iterated when scrapping
      :price_increment => 0.0,               # Price increment to all found items
      :simulate_error_at_node => fixnum_max, # Simulate an error at the nth node
      :simulated_error => RuntimeError       # Type of the error to simulate
    }
  end

  default_params.each_key do |param_name|
    attr_accessor param_name
  end

  def initialize(params = {})
    StoreScrappingTestStrategy.default_params.merge(params).each do |name, value|
      self.send((name.to_s+"=").intern, value)
    end
    @node_index = 0
  end

  def skip_link?(uri)
    uri =~ skip_link_regex
  end
  def each_node(collection)
    i = 0
    collection.each do |item|
      if max_loop_nodes <= i
        return
      else
        raise simulated_error.new("Test mock simulated error.") unless @node_index != simulate_error_at_node
        @node_index = @node_index + 1

        yield item
      end
      i = i+1
    end
  end
  def enrich_item(params)
    result = params.clone
    result[:price] += price_increment
    result
  end
end


