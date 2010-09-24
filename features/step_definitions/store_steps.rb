# Copyright (C) 2010 by Philippe Bourgau

Given /^an online store "([^"]*)""?$/ do |webStore|
  url = "http://"+webStore
  @tweaks = {:skip_links_like => /^http:\/\/auchandirect/, :squeeze_loops_to => 3}

  if offline?
    url = AUCHAN_DIRECT_OFFLINE
    @tweaks[:skip_links_like] = /^http:\/\//
  end

  @store = Store.find_or_create_by_url(url)
end

Given /^products from the online store were already imported$/ do
  when_importing_from(@store.scrapper, @tweaks)
  @store.import
  @previous_item_count = Item.count
  @previous_item_modification_time = Item.maximum(:updated_at)
  @previous_item_insertion_time = Item.maximum(:created_at)
end

When /^products from the online store are (re-)?imported$/ do |_|
  when_importing_from(@store.scrapper, @tweaks)
  @store.import
end

When /^more products from the online store are (re-)?imported$/ do |_|
  large_tweaks = @tweaks.clone
  large_tweaks[:squeeze_loops_to => 4]
  when_importing_from(@store.scrapper, large_tweaks)
  @store.import
end

