# -*- coding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

require "uri"
require_relative 'api_builder'

module MesCourses
  module Stores
    module Items

      define_api RealDummyConstants::ROOT_DIR_NAME do

        categories 'a.category' do
          attributes do
            { :name => page.get_one("h1").content }
          end

          categories 'a.category' do
            attributes do
              { :name => page.get_one("h1").content }
            end

            items 'a.item' do
              attributes do
                {
                  :name => page.get_one('h1').content,
                  :summary => page.get_one('#summary').content,
                  :price => page.get_one('#price').content.to_f,
                  :image => page.get_one('#image').content,
                  :remote_id => page.get_one('#remote_id').content
                }
              end
            end
          end
        end
      end
    end
  end
end
