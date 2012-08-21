# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses
  module Stores
    module Items
      # Error thrown when store item browsing fails due to unexpected page formatting
      class BrowsingError < StandardError
      end
    end
  end
end