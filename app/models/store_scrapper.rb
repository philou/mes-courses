# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'rubygems'
require 'mechanize'
require 'store_scrapping_strategy'
require 'lib/logging'
require 'lib/uri_domain'

# Objects able to dig into an online store and notify their "store" about
# the items and item categories that they found for sale.
class StoreScrapper

  # Options can be passed in, such as a custom :scrapping_strategy
  def initialize(options = {})
    if options.has_key?(:scrapping_strategy)
      @strategy = options[:scrapping_strategy]
    else
      @strategy = StoreScrappingStrategy.new
    end
  end

  # Imports the items sold from the online store to our db
  def import(url, store)
    @store = store
    if @store.last_import_finished?
      log :info, "Starting new import from #{url}"
      @store.starting_import
    else
      log :info, "Resuming import from #{url}"
    end

    agent = Mechanize.new do |agent|
      # NOTE: by default Mechanize has infinite history, and causes memory leaks
      agent.history.max_size = 0
    end
    mainPage = agent.get(url)
    walk_main_page(mainPage)

    @store.finishing_import
    log :info, "Finished import"
    @store = nil
  end

  private

  attr_reader :store, :strategy

  def walk_main_page(page)
    unless_already_visited(page) do
      follow_page_links(page, '#carroussel > div a', :walk_catalogue_page)
    end
  end

  def walk_catalogue_page(page, parent)
    walk_category_page(page, '#blocCentral > div a', :walk_rayon_page, parent)
  end

  def walk_rayon_page(page, parent)
    walk_category_page(page, '#blocs_articles a.lienArticle', :walk_produit_page, parent)
  end

  def walk_category_page(page, selector, message, parent)
    unless_already_visited(page) do
      name = category_name(page)
      item_category = store.register_item_category(:name => name, :parent => parent)
      follow_page_links(page, selector, message, item_category)
    end
  end

  def category_name(page)
    get_one(page, "#bandeau_label_recherche").content
  end

  def walk_produit_page(page, item_category)
    unless_already_visited(page) do
      params = { :item_category => item_category }

      # play with nokogiri in irb to know exactly how css, xpath and search methods work
      type_produit = get_one(page, '.typeProduit')
      params[:name] = get_one_css(page, type_produit, '.nomRayon').content
      params[:summary] = get_one_css(page, type_produit, '.nomProduit').content
      infos_produit = get_one(page, '#infosProduit')
      params[:price] = get_one_css(page, infos_produit, '.prixQteVal1').content.to_f
      params[:image] = get_one_css(page, infos_produit, '#imgProdDetail')['src']
      params = strategy.enrich_item(params)

      log :info, "Found item #{params.inspect}"
      store.register_item(params)
    end
  end

  # Searches for links with a Nokogiri css or xpath selector
  def search_links(page, selector)
    page.search(selector).map do |xmlA|
      Mechanize::Page::Link.new(xmlA, page.mech, page)
    end
  end

  # Filtered links with a Nokogiri css or xpath selector.
  # The result should not contain two links with the same uri.
  def links_with(page, selector)
    uri2links = {}
    search_links(page,selector).each do |link|
      target_uri = link.uri
      uri2links[target_uri.to_s] = link if keep_link? page.uri, target_uri
    end
    # enforcing deterministicity for testing and debugging
    uri2links.values.sort_by {|link| link.uri.to_s }
  end

  # Should the link be kept or skipped when walking through the online store
  def keep_link?(source_uri, target_uri)
    target_uri.relative? || (source_uri.domain == target_uri.domain)
  end

  # Follows selected links and calls 'message' on the opened pages.
  def follow_page_links(page, selector, message, parent = nil)
    strategy.each_node(links_with(page, selector)) do |link|
      self.send(message, link.click, parent)
    end
  end

  def unless_already_visited(page)
    if already_visited?(page)
      log :info, "Skipping #{page.uri}"
    else
      with_rescue "Following link #{page.uri}" do
        yield
        register_visited(page)
      end
    end
  end

  def already_visited?(page)
    store.already_visited_url?(page.uri.to_s)
  end

  def register_visited(page)
    store.register_visited_url(page.uri.to_s)
  end

  def with_rescue(summary)
    begin
      log :info, summary
      yield

    rescue ScrappingError => e
      log :warn, "Failed: \"#{summary}\" because "+ e
      # continue
    rescue Exception => e
      log :error, "Failed: \"#{summary}\" because "+ e
      raise
    end
  end

  def log(level, message)
    if (Rails.logger.respond_to?(:mongoize) && (Rails.logger.level < Logger::SYMBOL_2_LEVEL[level]))
      Rails.logger.send(Logger::LEVEL_2_SYMBOL[Rails.logger.level], message)
    end
    Rails.logger.send(level, message)
  end

  # searching xpath and css wrappers
  def get_one(page, selector)
    check_one("Page \"#{page.uri}\"", selector, page.search(selector))
  end
  def get_one_css(page, element, selector)
    check_one("In page \"#{page.uri}\", element \"#{element.path}\"", selector, element.css(selector))
  end
  def check_one(element_string, selector, elements)
    if elements.empty?()
      raise ScrappingError.new("#{element_string} does not contain any elements like \"#{selector}\"")
    end
    elements.first
  end

end
