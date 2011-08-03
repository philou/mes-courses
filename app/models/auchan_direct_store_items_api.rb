# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'rubygems'
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

  # Filtered links with a Nokogiri css or xpath selector.
  # The result should not contain two links with the same uri.
  def links_with(page, selector)
    uri2links = {}
    page.search_links(selector).each do |link|
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

  # searching xpath and css wrappers
  def get_one(page, selector)
    check_one("Page \"#{page.uri}\"", selector, page.search(selector))
  end
  def get_one_css(page, element, selector)
    check_one("In page \"#{page.uri}\", element \"#{element.path}\"", selector, element.css(selector))
  end
  def check_one(element_string, selector, elements)
    if elements.empty?
      raise StoreItemsBrowsingError.new("#{element_string} does not contain any elements like \"#{selector}\"")
    end
    elements.first
  end

  protected
  def scrap_attributes
    {}
  end

end


# Objects able to walk a store and discover available items
class AuchanDirectStoreItemsAPI
  include Walker

  def initialize(url)
    @agent = Mechanize.new do |agent|
      # NOTE: by default Mechanize has infinite history, and causes memory leaks
      agent.history.max_size = 0
    end

    @page = @agent.get(url)
  end

  def categories
    links_with(page, '#carroussel > div a').map { |link| AuchanDirectCategoryWalker.new(link) }
  end

  private
  attr_reader :page
end

class AuchanDirectCategoryWalker
  include Walker

  def initialize(link)
    @link = link
  end

  def link_text
    @link.text
  end

  def categories
    links_with(page, '#blocCentral > div a').map { |link| AuchanDirectSubCategoryWalker.new(link) }
  end

  protected
  def scrap_attributes
    { :name => get_one(page, "#bandeau_label_recherche").content }
  end
  def page
    @page ||= @link.click
  end
end

class AuchanDirectSubCategoryWalker
  include Walker

  def initialize(link)
    @link = link
  end

  def link_text
    @link.text
  end

  def items
    links_with(page, '#blocs_articles a.lienArticle').map { |link| AuchanDirectItemWalker.new(link) }
  end

  protected
  def scrap_attributes
    { :name => get_one(page, "#bandeau_label_recherche").content }
  end
  def page
    @page ||= @link.click
  end
end

class AuchanDirectItemWalker
  include Walker

  def initialize(link)
    @link = link
  end

  def link_text
    @link.text
  end

  protected
  def scrap_attributes
    product_type = get_one(page, '.typeProduit')
    product_infos = get_one(page, '#infosProduit')

    remote_id = /article\/(\d+)(\.html)?$/.match(page.uri.to_s)[1].to_i

    return {
      :name => get_one_css(page, product_type, '.nomRayon').content,
      :summary => get_one_css(page, product_type, '.nomProduit').content,
      :price => get_one_css(page, product_infos, '.prixQteVal1').content.to_f,
      :image => get_one_css(page, product_infos, '#imgProdDetail')['src'],
      :remote_id => remote_id
    }
  end

  def page
    @page ||= @link.click
  end
end
