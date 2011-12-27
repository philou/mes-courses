# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'store_walker_page'

module Walker
  attr_accessor :categories_digger, :items_digger, :scrap_attributes_block, :father, :index

  def initialize
    self.categories_digger = NullStoreItemsDigger.new
    self.items_digger = NullStoreItemsDigger.new
    self.scrap_attributes_block = lambda do { } end
  end

  def uri
    page.uri
  end
  def attributes
    @attributes ||= scrap_attributes
  end
  def categories
    @categories_digger.sub_walkers(page, self)
  end
  def items
    @items_digger.sub_walkers(page, self)
  end

  def to_s
    "#{self.class} ##{index} @ #{uri}"
  end

  protected

  def genealogy_to_s
    genealogy.join("\n")
  end
  def genealogy
    if father.nil?
      []
    else
      father.genealogy + [to_s]
    end
  end

  def scrap_attributes
    instance_eval(&@scrap_attributes_block)
  end
end


# Objects able to walk a store and discover available items
class StoreItemsAPI
  include Walker

  def initialize(url)
    @agent = Mechanize.new do |agent|
      # NOTE: by default Mechanize has infinite history, and causes memory leaks
      agent.history.max_size = 0
    end

    @page = StoreWalkerPage.new(@agent.get(url))
  end

  private
  attr_reader :page
end

class SubStoreItemsAPI
  include Walker

  def initialize(link)
    @link = link
  end

  def page
    @page = StoreWalkerPage.new(@link.click) if @page.nil?
    @page
  end
end

class StoreItemsDigger
  def initialize(selector, factory)
    @selector = selector
    @factory = factory
  end

  def sub_walkers(page, father)
    page.search_links_in_same_domain(@selector).each_with_index.map { |link, i| @factory.new(link, father, i) }
  end
end
class NullStoreItemsDigger
  def sub_walkers(page, father)
    []
  end
end
