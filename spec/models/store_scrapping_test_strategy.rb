# Copyright (C) 2010 by Philippe Bourgau

# maximum fixnum value
def fixnum_max
  2**(0.size * 8 -2) -1
end

# Cusom testing strategy for store scrapping
class StoreScrappingTestStrategy

  # Default accepted options
  def self.default_params
    { :skip_links_like => /^$/,            # Regex to match skiped links
      :squeeze_loops_to => fixnum_max,     # Max count of nodes that can be iterated when scrapping
      :increase_price_by => 0.0,           # Price increment to all found items
      :continue_on_error => true,          # Should we continue on a scrapping error ?
      :network_down_at_node => fixnum_max} # Simulate a network when scrapping nth node
  end

  def initialize(params)
    # TODO to simplify
    #  use params directly as unique member
    #  use meaningfull test default values
    params = StoreScrappingTestStrategy.default_params.merge(params)
    @skipped_links_regex = params[:skip_links_like]
    @max_nodes = params[:squeeze_loops_to]
    @price_increment = params[:increase_price_by]
    @continue_on_error = params[:continue_on_error]
    @network_down_at_node = params[:network_down_at_node]

    @node_index = 0
  end

  def skip_link?(uri)
    uri =~ @skipped_links_regex
  end
  def each_node(collection)
    i = 0
    collection.each do |item|
      if @max_nodes <= i
        return
      else
        @node_index = @node_index + 1
        raise Exception.new("Network down test mock error.") unless @node_index < @network_down_at_node

        yield item
      end
      i = i+1
    end
  end
  def enrich_item(params)
    result = params.clone
    result[:price] += @price_increment
    result
  end
  def handle_exception
    raise unless @continue_on_error
  end
end


