# Copyright (C) 2010 by Philippe Bourgau

Given /^the "([^"]*)"( online)? store"?$/ do |webStore, online_store|
  url = AUCHAN_DIRECT_OFFLINE
  @tweaks = {:skip_links_like => /^http:\/\//, :squeeze_loops_to => 3, :continue_on_error => false}

  if !online_store.blank? && !offline?
    url = "http://"+webStore
    @tweaks[:skip_links_like] = /^http:\/\/auchandirect/
  end

  @store = Store.find_or_create_by_url(url)
end

Given /^items from the store were already imported$/ do
  lazy_import_with(@store, @tweaks)
end

Given /^last store import was unexpectedly interrupted$/ do
  begin
    import_with(@store, @tweaks.merge(:network_down_at_node => 7))
  rescue Exception
    # fake network error
  end
end

When /^items from the store are imported$/ do
  import_with(@store, @tweaks)
end

When /^items from the store are re-imported$/ do
  reimport(@store, @tweaks)
end

When /^more items from the store are re-imported$/ do
  reimport(@store, @tweaks, :squeeze_loops_to => 4)
end

When /^modified items from the store are re-imported$/ do
  reimport(@store, @tweaks, :increase_price_by => 1.1)
end

When /^sold out items from the store are re-imported$/ do
  reimport(@store, @tweaks, :squeeze_loops_to => 2)
end

