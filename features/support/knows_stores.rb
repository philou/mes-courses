# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsStores

  def create_new_store(uri)
    Store.find_or_create_by_url(uri) { |store| store.sponsored_url = "#{uri}/sponsored" }
  end

end
World(KnowsStores)
