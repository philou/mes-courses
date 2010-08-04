Given /^an online store "([^"]*)"$/ do |webStore|
  @store = Store.find_or_create_by_url(webStore)
end

When /^products from the online store are imported$/ do
  do_not_follow_more_than_3_similar_links_when_importing_from(@store)
  @store.import
end

