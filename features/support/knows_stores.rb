# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require "uri"

module KnowsStores

  def main_store_name
    @main_store_name ||= "www.dummy-store.com"
  end
  def register_store_name(store_name)
    @main_store_name ||= store_name
  end

  def create_new_store(uri)
    Store.find_or_create_by_url(uri) { |store| store.sponsored_url = "#{uri}/sponsored" }
  end

end
World(KnowsStores)
