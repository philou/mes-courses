# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013, 2014 by Philippe Bourgau

require 'auchandirect/scrAPI'

module MesCourses
  module Stores
    module Carts

      class Api

        # factory of store cart api for a given url
        def self.for_url(store_url)
          if store_url == Auchandirect::ScrAPI::Cart.url
            Auchandirect::ScrAPI::Cart
          elsif store_url.include?(Auchandirect::ScrAPI::DummyCart.url)
            Auchandirect::ScrAPI::DummyCart
          else
            raise ArgumentError.new("No store api found for store at '#{store_url}'")
          end
        end
      end
    end
  end
end
