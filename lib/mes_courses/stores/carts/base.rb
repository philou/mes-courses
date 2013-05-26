# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Stores
    module Carts

      # Providers of Store cart session
      class Base

        # A new provider of store cart sessions for a given url
        def self.for_url(store_url)
          Base.new(Api.for_url(store_url))
        end

        # Logs in the store account of a user and returns a Session instance
        def login(login, password)
          Session.new(@api_factory.login(login, password))
        end

        # url for a client browser to log off the store
        def logout_url
          @api_factory.logout_url
        end

        # html form for a client browser to login
        def login_form_html
          @api_factory.login_form_html
        end

        private
        def initialize(api_factory)
          @api_factory = api_factory
        end
      end
    end
  end
end
