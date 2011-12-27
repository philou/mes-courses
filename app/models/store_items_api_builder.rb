# Copyright (C) 2011 by Philippe Bourgau

require 'store_items_api_walker.rb'

class StoreItemsAPIBuilder

  def self.define(&block)
    returning new do |result|
      result.instance_eval(&block)
    end
  end

  def initialize()
    @categories_digger = NullStoreItemsDigger.new
  end

  def categories(selector, &block)
    @categories_digger = StoreItemsDigger.new(selector, SubStoreItemsAPIBuilder.define(&block))
  end

  def new(url)
    returning StoreItemsAPI.new(url) do |result|
      result.categories_digger = @categories_digger
    end
  end
end

class SubStoreItemsAPIBuilder

  def self.define(&block)
    returning new do |result|
      result.instance_eval(&block)
    end
  end

  def initialize()
    @scrap_attributes_block = lambda do {} end
    @categories_digger = NullStoreItemsDigger.new
    @items_digger = NullStoreItemsDigger.new
  end

  def attributes(&block)
    @scrap_attributes_block = block
  end

  def categories(selector, &block)
    @categories_digger = StoreItemsDigger.new(selector, SubStoreItemsAPIBuilder.define(&block))
  end

  def items(selector, &block)
    @items_digger = StoreItemsDigger.new(selector, SubStoreItemsAPIBuilder.define(&block))
  end

  def new(link, father, index)
    returning SubStoreItemsAPI.new(link) do |result|
      result.categories_digger = @categories_digger
      result.items_digger = @items_digger
      result.scrap_attributes_block = @scrap_attributes_block
      result.father = father
      result.index = index
    end
  end
end




def define_store_items_api(name, &block)
  builder = StoreItemsAPIBuilder.define &block

  self.class.send :define_method, name do |url|
    builder.new(url)
  end
end
