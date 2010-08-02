Given /^an online store "([^"]*)"$/ do |webStore|
  @store = Store.create!(:url => webStore)
end

When /^products from the online store are imported$/ do
  do_not_follow_more_than_3_similar_links_when_importing_from(@store)
  @store.import
end

