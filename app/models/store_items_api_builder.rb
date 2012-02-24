# Copyright (C) 2011, 2012 by Philippe Bourgau

class StoreItemsAPIBuilder

  def self.define(api_class, digger_class, &block)
    new(api_class, digger_class).tap do |result|
      result.instance_eval(&block)
    end
  end

  def initialize(api_class, digger_class)
    @api_class = api_class
    @digger_class = digger_class
    @scrap_attributes_block = lambda do {} end
    @categories_digger = NullStoreItemsDigger.new
    @items_digger = NullStoreItemsDigger.new
  end

  def attributes(&block)
    @scrap_attributes_block = block
  end

  def categories(selector, &block)
    @categories_digger = @digger_class.new(selector, StoreItemsAPIBuilder.define(@api_class, @digger_class, &block))
  end

  def items(selector, &block)
    @items_digger = @digger_class.new(selector, StoreItemsAPIBuilder.define(@api_class, @digger_class, &block))
  end

  def new(page_getter, father = nil, index = nil)
    @api_class.new(page_getter).tap do |result|
      result.categories_digger = @categories_digger
      result.items_digger = @items_digger
      result.scrap_attributes_block = @scrap_attributes_block
      result.father = father
      result.index = index
    end
  end

end


def define_store_items_api(name, &block)
  builder = StoreItemsAPIBuilder.define(StoreItemsWalker, StoreItemsDigger, &block)

  self.class.send :define_method, name do |url|
    builder.new(StoreWalkerPage.open(url))
  end
end
