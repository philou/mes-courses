# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Stores
    module Carts

      # Providers of Store cart session
      class Base
        extend Forwardable

        # A new provider of store cart sessions for a given url
        def self.for_url(store_url)
          Base.new(Api.for_url(store_url))
        end

        # Logs in the store account of a user and returns a Session instance
        def login(login, password)
          Session.new(@api_factory.login(login, password))
        end

        def_delegators :@api_factory, :logout_url, :login_url, :login_parameters, :login_parameter, :password_parameter

        private
        def initialize(api_factory)
          @api_factory = api_factory
        end
      end
    end
  end
end
