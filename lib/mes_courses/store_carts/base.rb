# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses::StoreCarts

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

    private
    def initialize(api_factory)
      @api_factory = api_factory
    end
  end

end
