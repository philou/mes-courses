# Copyright (C) 2010 by Philippe Bourgau

Given /^"([^"]*)" for sale$/ do |item_name|
  @item_for_sale = Item.create!(:name => item_name)
end

Then /^there should be some items for sale$/ do
  Item.should have_at_least(10).records
end

Then /^all items should be organized by type and subtype$/ do

  Item.find(:all).each do |item|
    item.sub_type.should_not be_nil
    item.sub_type.type.should_not be_nil
  end

end
