
Given /^"([^"]*)" for sale$/ do |item_name|
  @item_for_sale = Item.create!(:name => item_name)
end

Then /^there should be some items for sale$/ do
  Item.should have_at_least(10).records
end
