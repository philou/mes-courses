# Copyright (C) 2010 by Philippe Bourgau

Then /^there should be some items for sale$/ do
  Item.should have_at_least(10).records
end

Then /^all items should be organized by type and subtype$/ do
  Item.find(:all).each do |item|
    item.item_sub_type.should_not be_nil
    item.item_sub_type.item_type.should_not be_nil
  end
end

Then /^all items should have an? (.*)$/ do |attribute|
  Item.find(:all).should all have_non_nil(attribute)
end

Then /^most items should have an? (.*)$/ do |attribute|
  Item.find(:all).should mostly have_non_nil(attribute)
end

Given /^"([^">]*) > ([^">]*) > ([^">]*)" item$/ do |item_type_name, item_sub_type_name, item_name|
  item_type = ItemType.find_or_create_by_name(item_type_name)
  item_sub_type = ItemSubType.create!(:name => item_sub_type_name, :item_type => item_type)
  @item = Item.create!(:name => item_name, :item_sub_type => item_sub_type)
end
