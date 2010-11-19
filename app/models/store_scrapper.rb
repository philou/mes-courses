# Copyright (C) 2010 by Philippe Bourgau

require 'rubygems'
require 'mechanize'
require 'store_scrapping_strategy'

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
      Rails.logger.info "Starting new import from #{url}"
      @store.starting_import
    else
      Rails.logger.info "Resuming import from #{url}"
    end

    agent = Mechanize.new
    mainPage = agent.get(url)
    walk_main_page(mainPage)

    @store.finishing_import
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
    page.search("#bandeau_label_recherche").first.content
  end

  def walk_produit_page(page, item_category)
    unless_already_visited(page) do
      params = { :item_category => item_category }

      # play with nokogiri in irb to know exactly how css, xpath and search methods work
      type_produit = page.search('.typeProduit').first
      params[:name] = type_produit.css('.nomRayon').first.content
      params[:summary] = type_produit.css('.nomProduit').first.content
      infos_produit = page.search('#infosProduit').first
      params[:price] = infos_produit.css('.prixQteVal1').first.content.to_f
      params[:image] = infos_produit.css('#imgProdDetail').first['src']
      params = strategy.enrich_item(params)

      Rails.logger.info "Found item #{params.inspect}"
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
      uri = link.uri.to_s
      uri2links[uri] = link unless strategy.skip_link? uri
    end
    # enforcing deterministicity for testing and debugging
    uri2links.values.sort_by {|link| link.uri.to_s }
  end

  # Follows selected links and calls 'message' on the opened pages.
  def follow_page_links(page, selector, message, parent = nil)
    strategy.each_node(links_with(page, selector)) do |link|
      self.send(message, link.click, parent)
    end
  end

  def unless_already_visited(page)
    if already_visited?(page)
      Rails.logger.info "Skipping #{page.uri}"
    else
      with_rescue "Following link #{page.uri}" do
        Rails.logger.with_tabs do
          yield
        end
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
      Rails.logger.info summary
      yield

    rescue StandardError => e
      Rails.logger.warn "Failed: \"#{summary}\" because "+ e
      strategy.handle_exception
    rescue Exception => e
      Rails.logger.warn "Failed: \"#{summary}\" because "+ e
      raise
    end
  end

end
