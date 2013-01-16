# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'mechanize'

# monkey patch to avoid a regex uri encoding error when importing
#      incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string) (Encoding::CompatibilityError)
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:353:in `gsub'
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:353:in `_escape'
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:363:in `escape'
#      from uri method
require "webrick/httputils"
module WEBrick::HTTPUtils
  def self.escape(s)
    URI.escape(s)
  end
end

class Mechanize
  module Searcher
    def search_links(selector)
      search(selector).map {|node| Page::Link.new(node, @mech, self)}
    end
    def search_images(selector)
      search(selector).map {|node| Page::Image.new(node, self)}
    end
  end
  Page.send(:include, Searcher)
end

module MesCourses
  module Stores
    module Items

      class WalkerPage

        def self.open(uri)
          Getter.new(uri)
        end

        delegate :uri, :to => :@mechanize_page

        def search_links(selector)
          uri2links = {}
          search_all_links(selector).each do |link|
            target_uri = link.uri
            uri2links[target_uri.to_s] = link if same_domain? uri, target_uri
          end
          # enforcing deterministicity for testing and debugging
          uri2links.values.sort_by {|link| link.uri.to_s }
        end

        def get_one(*selectors)
          elements = selectors.map {|selector| @mechanize_page.search(selector)}.flatten
          first_or_throw(elements, "elements", selectors)
        end

        def get_image(selector)
          first_or_throw(@mechanize_page.search_images(selector), "images", selector)
        end

        private

        def initialize(mechanize_page)
          @mechanize_page = mechanize_page
        end

        def same_domain?(source_uri, target_uri)
          target_uri.relative? || (source_uri.domain == target_uri.domain)
        end

        def search_all_links(selector)
          @mechanize_page.search_links(selector).map { |link| Link.new(link) }
        end

        def first_or_throw(elements, name, selector)
          if elements.empty?
            raise WalkerPageError.new("Page \"#{uri}\" does not contain any #{name} like \"#{selector}\"")
          end
          elements.first
        end

        class Getter
          attr_reader :uri

          def initialize(uri)
            @uri = uri
          end
          def get
            @page ||= get_page
          end

          def text
            @uri.to_s
          end

          private

          def get_page
            agent = Mechanize.new do |it|
              # NOTE: by default Mechanize has infinite history, and causes memory leaks
              it.history.max_size = 0
            end

            WalkerPage.new(agent.get(@uri))
          end
        end

        class Link
          def initialize(mechanize_link)
            @mechanize_link = mechanize_link
          end

          delegate :uri, :to => :@mechanize_link

          def get
            WalkerPage.new(@mechanize_link.click)
          end

          def text
            @mechanize_link.text
          end
        end
      end
    end
  end
end
