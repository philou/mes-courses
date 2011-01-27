# Copyright (C) 2010, 2011 by Philippe Bourgau

Given /^the "([^"]*)" *(online)? store"?$/ do |webStore, online_store|
  test_online_if_possible = !online_store.blank?

  url = AUCHAN_DIRECT_OFFLINE
  @tweaks = {}

  if test_online_if_possible && online?
    url = "http://"+webStore
  end

  @store = Store.find_or_create_by_url(url)
end

Given /^items from the store were already imported$/ do
  lazy_import_with(@store, @tweaks)
end

Given /^last store import was unexpectedly interrupted$/ do
  begin
    import_with(@store, @tweaks.merge(:simulate_error_at_node => 7))
  rescue RuntimeError
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
  reimport(@store, @tweaks, :max_loop_nodes => 4)
end

When /^modified items from the store are re-imported$/ do
  reimport(@store, @tweaks, :price_increment => 1.1)
end

When /^sold out items from the store are re-imported$/ do
  reimport(@store, @tweaks, :max_loop_nodes => 2)
end

