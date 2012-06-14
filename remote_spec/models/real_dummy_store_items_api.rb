# -*- coding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

require "uri"
require "webrick/httputils"

# monkey patch to avoid a regex uri encoding error when importing
#      incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string) (Encoding::CompatibilityError)
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:353:in `gsub'
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:353:in `_escape'
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:363:in `escape'
#      ./app/models/store_walker_page.rb:83:in `uri'
module WEBrick::HTTPUtils
  def self.escape(s)
    URI.escape(s)
  end
end


require 'store_items_api_builder'
define_store_items_api RealDummyStore::ROOT_DIR_NAME do

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
            :remote_id => page.get_one('#remote_id').content.to_i
          }
        end
      end
    end
  end
end

