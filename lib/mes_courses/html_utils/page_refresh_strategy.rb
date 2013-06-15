# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module MesCourses
  module HtmlUtils
    class PageRefreshStrategy

      class None
        def ==(other)
          other.instance_of?(self.class)
        end

        def to_html
          ''.html_safe
        end
      end

      def self.none
        None.new
      end

      def initialize(options = {})
        @interval = options[:interval] || 3
        @url = options[:url]
      end

      def ==(other)
        other.respond_to?(:to_html) && to_html == other.to_html
      end

      def to_html
        "<meta http-equiv=\"refresh\" content=\"#{html_meta_content}\" />".html_safe
      end

      private

      def html_meta_content
        "#{@interval}#{html_meta_content_url}"
      end

      def html_meta_content_url
        return "" if @url.nil?

        "; url=#{@url}"
      end
    end
  end
end
