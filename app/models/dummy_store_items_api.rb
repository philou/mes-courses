# Copyright (C) 2011 by Philippe Bourgau

class DummyStoreItemsAPI
  def initialize(attributes)
    values = { :items => [], :categories => [], :uri => DummyStoreItemsAPI.unique_uri }.merge(attributes)

    @uri = values[:uri]
    @attributes = values.reject{ |k,v| [:items, :uri, :categories].include?(k) }
    @items = DummyStoreItemsAPI.news(values[:items])
    @categories = DummyStoreItemsAPI.news(values[:categories])
  end

  def self.new_store(root_categories)
    new(:categories => root_categories)
  end

  def self.new_milk_store(uri)
    new(:uri => URI.parse(uri),
        :categories => [{ :name => "Produits laitiers",
                          :categories => [{ :name => "Lait",
                                            :items => [{ :name => "Lait enier",
                                                         :summary => "Lait entier",
                                                         :price => 0.67,
                                                         :remote_id => 12345 }]}]}])
  end

  attr_reader :uri, :attributes, :items, :categories

  def link_text
    attributes[:name]
  end

  private

  def self.unique_uri
    @uri_counter ||= 0
    URI.parse("http://www.dummystore.com/article/#{@uri_counter += 1}")
  end

  def self.news(attributes_array)
    attributes_array.map { |attributes| new(attributes) }
  end

end

