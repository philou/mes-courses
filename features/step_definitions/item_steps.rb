
Given /^tomatoes for sale$/ do
  @tomatoes = Item.create!(:name => "Tomatoes")
end

Then /^there should be some products for sale$/ do
  Item.exists?.should be_true
end
