require 'rubygems'
require 'mechanize'

# Backend online store of a distributor
class Store < ActiveRecord::Base

  # Imports the items sold from the online store to our db
  def import
    agent = Mechanize.new
    mainPage = agent.get(url)

    walkMainPage(mainPage)
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
      uri2links[link.uri] = link unless skip_link? link.uri
    end
    uri2links.values
  end

  # Follows selected links and calls 'message' on the opened pages.
  def followPageLinks(page, selector, message)
    each_node(links_with(page, selector)) do |link|
      begin
        self.send(message, link.click)
        
      rescue Exception
        logger.warn 'Could not follow link "#{link.content}" because '+ $!

      end
    end
  end

  
  def walkMainPage(page)
    followPageLinks(page, '#carroussel > div a', :walkCataloguePage)
  end

  def walkCataloguePage(page)
    followPageLinks(page, '#blocCentral > div a', :walkRayonPage)
  end

  def walkRayonPage(page)
    each_node(page.search('.nomProduit')) do |element|
      name = element.search('.label2').first.content
      Item.create!(:name => name)
    end
  end

end
