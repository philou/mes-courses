
Given /^an online store "([^"]*)"$/ do |webStore|
  @store = Store.create!(:url => webStore)
end

When /^products from the online store are imported$/ do
  @store.import
end

