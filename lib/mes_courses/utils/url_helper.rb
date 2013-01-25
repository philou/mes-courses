# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module MesCourses
  module Utils
    module UrlHelper

      def https_url(url)
        url.gsub(/^http:/,'https:')
      end

    end
  end
end
