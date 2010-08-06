Given /^an online store "([^"]*)"$/ do |webStore|
  @store = Store.find_or_create_by_url(webStore)
end

When /^products from the online store are imported$/ do
  when_importing_from(@store, :skip_links_like => /^http:\/\/auchandirect/, :squeeze_loops_to => 3)
  @store.import
end

