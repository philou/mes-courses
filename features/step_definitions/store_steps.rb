Given /^an online store "([^"]*)"$/ do |webStore|
  url = "http://"+webStore
  @tweaks = {:skip_links_like => /^http:\/\/auchandirect/, :squeeze_loops_to => 3}

  if offline?
    url = AUCHAN_DIRECT_OFFLINE
    @tweaks[:skip_links_like] = /^http:\/\//
  end

  @store = Store.find_or_create_by_url(url)
end

When /^products from the online store are imported$/ do
  when_importing_from(@store, @tweaks)
  @store.import
end

