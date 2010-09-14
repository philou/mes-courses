# Copyright (C) 2010 by Philippe Bourgau

require 'rubygems'
require 'mechanize'

# Objects able to dig into an online store and notify their "importer" about
# the items and item categories that they found for sale.
class Scrapper

  # Imports the items sold from the online store to our db
  def import(url, importer)
    @importer = importer

    Rails.logger.info "Starting import from #{url}"
    agent = Mechanize.new
    mainPage = agent.get(url)
    Rails.logger.with_tabs { walk_main_page(mainPage) }

    @importer = nil
  end

  private

  attr_reader :importer

  # Should the link be skipped when walking through the online store
  # This method can be overriden for testing purpose
  def skip_link?(uri)
    false
  end

  # 'each' synonym for html nodes
  # This method can be overriden for testing purpose
  def each_node(collection)
    collection.each {|item| yield item }
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
      uri2links[uri] = link unless skip_link? uri
    end
    # enforcing deterministicity for testing and debugging
    uri2links.values.sort_by {|link| link.uri.to_s }
  end

  # Follows selected links and calls 'message' on the opened pages.
  def follow_page_links(page, selector, message, *privateArgs)
    each_node(links_with(page, selector)) do |link|
      begin
        Rails.logger.info "Following #{link.uri}"
        Rails.logger.with_tabs { self.send(message, link.click, *privateArgs)}

      rescue Exception
        Rails.logger.warn "Could not follow link \"#{link.uri}\" because "+ $!

      end
    end
  end

  def walk_main_page(page)
    follow_page_links(page, '#carroussel > div a', :walk_catalogue_page)
  end

  def walk_catalogue_page(page)
    name = item_type_name(page)
    item_type = importer.found_item_type(:name => name)
    follow_page_links(page, '#blocCentral > div a', :walk_rayon_page, item_type)
  end

  def walk_rayon_page(page, item_type)
    name = item_type_name(page)
    item_sub_type = importer.found_item_sub_type(:name => name, :item_type => item_type)
    follow_page_links(page, '#blocs_articles a.lienArticle', :walk_produit_page, item_sub_type)
  end

  def item_type_name(page)
    page.search("#bandeau_label_recherche").first.content
  end

  def walk_produit_page(page, item_sub_type)
    params = { :item_sub_type => item_sub_type }

    # play with nokogiri in irb to know exactly how css, xpath and search methods work
    type_produit = page.search('.typeProduit').first
    params[:name] = type_produit.css('.nomRayon').first.content
    params[:summary] = type_produit.css('.nomProduit').first.content
    infos_produit = page.search('#infosProduit').first
    params[:price] = infos_produit.css('.prixQteVal1').first.content
    params[:image] = infos_produit.css('#imgProdDetail').first['src']

    Rails.logger.info "Found item #{params}"
    importer.found_item(params)
  end

end
