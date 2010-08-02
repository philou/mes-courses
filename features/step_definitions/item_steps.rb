
Given /^tomatoes for sale$/ do
  @tomatoes = Item.create!(:name => "Tomatoes")
end

Then /^there should be some products for sale$/ do
  Item.should have_at_least(10).records
end
