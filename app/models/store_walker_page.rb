# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'mechanize'
require 'lib/uri_domain'

class StoreWalkerPage
  def initialize(mechanize_page)
    @mechanize_page = mechanize_page
  end

  #TODO try this : delegate :uri, :to => :mechanize_page
  def uri
    @mechanize_page.uri
  end

  def search_links_in_same_domain(selector)
    uri2links = {}
    search_links(selector).each do |link|
      target_uri = link.uri
      uri2links[target_uri.to_s] = link if same_domain? uri, target_uri
    end
    # enforcing deterministicity for testing and debugging
    uri2links.values.sort_by {|link| link.uri.to_s }
  end

  def get_one(selector)
    check_one("Page \"#{uri}\"", selector, search(selector))
  end
  def get_one_css(element, selector)
    check_one("In page \"#{uri}\", element \"#{element.path}\"", selector, element.css(selector))
  end

  private

  def same_domain?(source_uri, target_uri)
    target_uri.relative? || (source_uri.domain == target_uri.domain)
  end

  def search_links(selector)
    search(selector).map do |xmlA|
      Mechanize::Page::Link.new(xmlA, @mechanize_page.mech, @mechanize_page)
    end
  end

  def search(selector)
    @mechanize_page.search(selector)
  end

  def check_one(element_string, selector, elements)
    if elements.empty?
      raise StoreItemsBrowsingError.new("#{element_string} does not contain any elements like \"#{selector}\"\n#{genealogy_to_s}")
    end
    elements.first
  end

end
