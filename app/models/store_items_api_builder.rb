# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'mechanize'
require 'lib/uri_domain'

class Mechanize
  class Page
    # Searches for links with a Nokogiri css or xpath selector
    def search_links(selector)
      search(selector).map do |xmlA|
        Mechanize::Page::Link.new(xmlA, mech, self)
      end
    end
  end
end

module Walker
  def uri
    page.uri
  end
  def attributes
    @attributes ||= scrap_attributes
  end
  def categories
    []
  end
  def items
    []
  end

  protected

  # Filtered links with a Nokogiri css or xpath selector.
  # The result should not contain two links with the same uri.
  def links_with(page, selector)
    uri2links = {}
    page.search_links(selector).each do |link|
      target_uri = link.uri
      uri2links[target_uri.to_s] = link if keep_link? uri, target_uri
    end
    # enforcing deterministicity for testing and debugging
    uri2links.values.sort_by {|link| link.uri.to_s }
  end

  # Should the link be kept or skipped when walking through the online store
  def keep_link?(source_uri, target_uri)
    target_uri.relative? || (source_uri.domain == target_uri.domain)
  end

  # searching xpath and css wrappers
  def get_one(page, selector)
    check_one("Page \"#{uri}\"", selector, page.search(selector))
  end
  def get_one_css(page, element, selector)
    check_one("In page \"#{uri}\", element \"#{element.path}\"", selector, element.css(selector))
  end
  def check_one(element_string, selector, elements)
    if elements.empty?
      raise StoreItemsBrowsingError.new("#{element_string} does not contain any elements like \"#{selector}\"\n#{genealogy_to_s}")
    end
    elements.first
  end

  def genealogy_to_s
    genealogy.join("\n")
  end
  def genealogy
    if @father.nil?
      []
    else
      @father.genealogy + ["#{self.class} ##{@index} @ #{uri}"]
    end
  end

  def scrap_attributes
    {}
  end

  def sub_walkers(css, sub_walker_class)
    return [] if css.nil?

    links_with(page, css).each_with_index.map { |link, i| sub_walker_class.new(link, self, i) }
  end
end


# Objects able to walk a store and discover available items
class StoreItemsAPI
  include Walker

  def initialize(options, url)
    @options = options
    @agent = Mechanize.new do |agent|
      # NOTE: by default Mechanize has infinite history, and causes memory leaks
      agent.history.max_size = 0
    end

    @page = @agent.get(url)
  end

  def categories
    sub_walkers(categories_selector, categories_factory)
  end

  private
  attr_reader :page

  def categories_selector
    @options[:categories_selector]
  end
  def categories_factory
    @options[:categories_factory]
  end

end

class StoreWalker
  include Walker

  def initialize(options, scrap_attributes_block, link, father, index)
    @options = options
    @scrap_attributes_block = scrap_attributes_block
    @link = link
    @father = father
    @index = index
  end

  def link_text
    @link.text
  end

  def page
    @page ||= @link.click
  end

  def categories
    sub_walkers(categories_selector, categories_factory)
  end

  def items
    sub_walkers(items_selector, items_factory)
  end

  private
  def scrap_attributes
    instance_eval(&@scrap_attributes_block)
  end

  def items_selector
    @options[:items_selector]
  end
  def items_factory
    @options[:items_factory]
  end
  def categories_selector
    @options[:categories_selector]
  end
  def categories_factory
    @options[:categories_factory]
  end
end

class StoreItemsAPIBuilder

  def self.define(&block)
    returning new do |result|
      result.instance_eval(&block)
    end
  end

  def initialize()
    @options = {}
  end

  def categories(selector, &block)
    @options[:categories_selector] = selector
    @options[:categories_factory] = StoreWalkerBuilder.define(&block)
  end

  def new(url)
    StoreItemsAPI.new(@options, url)
  end
end

class StoreWalkerBuilder

  def self.define(&block)
    returning new do |result|
      result.instance_eval(&block)
    end
  end

  def initialize()
    @scrap_attributes_block = lambda do {} end
    @options = {}
  end

  def attributes(&block)
    @scrap_attributes_block = block
  end

  def categories(selector, &block)
    @options[:categories_selector] = selector
    @options[:categories_factory] = StoreWalkerBuilder.define(&block)
  end

  def items(selector, &block)
    @options[:items_selector] = selector
    @options[:items_factory] = StoreWalkerBuilder.define(&block)
  end

  def new(link, father, index)
    StoreWalker.new(@options, @scrap_attributes_block, link, father, index)
  end
end

def define_store_items_api(name, &block)
  builder = StoreItemsAPIBuilder.define &block

  self.class.send :define_method, name do |url|
    builder.new(url)
  end
end



