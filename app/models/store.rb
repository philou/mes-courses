require 'rubygems'
require 'mechanize'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  # Imports the items sold from the online store to our db
  def import
    agent = Mechanize.new
    mainPage = agent.get(url)

    walk_main_page(mainPage)
  end

private

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
  def follow_page_links(page, selector, message)
    each_node(links_with(page, selector)) do |link|
      begin
        self.send(message, link.click)
        
      rescue Exception
        logger.warn 'Could not follow link "#{link.content}" because '+ $!

      end
    end
  end

  
  def walk_main_page(page)
    follow_page_links(page, '#carroussel > div a', :walk_catalogue_page)
  end

  def walk_catalogue_page(page)
    follow_page_links(page, '#blocCentral > div a', :walk_rayon_page)
  end

  def walk_rayon_page(page)
    follow_page_links(page, '#blocs_articles a.lienArticle', :walk_produit_page)
  end

  def walk_produit_page(page)
    each_node(page.search('.typeProduit')) do |element|
      name = element.search('.nomRayon').first.content
      Item.create!(:name => name)
    end
  end

end
