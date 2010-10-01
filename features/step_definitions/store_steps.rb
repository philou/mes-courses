# Copyright (C) 2010 by Philippe Bourgau

# Imports the store using the tweaks
def import_with(store, tweaks)
  when_importing_from(store.scrapper, tweaks)
  store.import
end

# Imports the store using tweaks, if the import was already done,
# it just restores the database as after the import.
def lazy_import_with(store, tweaks)
  $import_clones ||= {}
  import_key = {:store => store.url, :tweaks => tweaks}

  if $import_clones.has_key?(import_key)
    clones = ActiveRecord::Base.deep_clones($import_clones[import_key])
    clones.each { |record| record.save }

  else
    import_with(store, tweaks)
    records = ItemType.find(:all) | ItemSubType.find(:all) | Item.find(:all)
    $import_clones[import_key] = ActiveRecord::Base.deep_clones(records)
  end
end

Given /^the "([^"]*)"( online)? store"?$/ do |webStore, online_store|
  url = AUCHAN_DIRECT_OFFLINE
  @tweaks = {:skip_links_like => /^http:\/\//, :squeeze_loops_to => 3}

  if !online_store.blank? && !offline?
    url = "http://"+webStore
    @tweaks[:skip_links_like] = /^http:\/\/auchandirect/
  end

  @store = Store.find_or_create_by_url(url)
end

Given /^products from the store were already imported$/ do
  lazy_import_with(@store, @tweaks)
  @previous_item_count = Item.count
  @previous_item_modification_time = Item.maximum(:updated_at)
  @previous_item_insertion_time = Item.maximum(:created_at)
end

When /^products from the store are imported$/ do
  lazy_import_with(@store, @tweaks)
end

When /^products from the store are re-imported$/ do
  when_importing_from(@store.scrapper, @tweaks)
  @store.import
end

When /^more products from the store are re-imported$/ do
  large_tweaks = @tweaks.clone
  large_tweaks[:squeeze_loops_to => 4]
  when_importing_from(@store.scrapper, large_tweaks)
  @store.import
end

