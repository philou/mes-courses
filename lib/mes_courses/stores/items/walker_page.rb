# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'mechanize'

module MesCourses::Stores::Items

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

    def get_one(selector)
      elements = @mechanize_page.search(selector)
      if elements.empty?
        raise WalkerPageError.new("Page \"#{uri}\" does not contain any elements like \"#{selector}\"")
      end
      elements.first
    end

    private

    def initialize(mechanize_page)
      @mechanize_page = mechanize_page
    end

    def same_domain?(source_uri, target_uri)
      target_uri.relative? || (source_uri.domain == target_uri.domain)
    end

    def search_all_links(selector)
      @mechanize_page.search(selector).map do |xmlA|
        Link.new(Mechanize::Page::Link.new(xmlA, @mechanize_page.mech, @mechanize_page))
      end
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
