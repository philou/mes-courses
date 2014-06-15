# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


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
