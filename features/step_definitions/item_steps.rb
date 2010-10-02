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

Then /^I should see the "([^"]*)" of "([^"]*)"$/ do |attribute, item_name|
  item = Item.find_by_name(item_name)
  attribute_text = item.send(attribute).to_s
  response.should contain(attribute_text)
end

Then /^I should see the "([^"]*)" of "([^"]*)" as img$/ do |attribute, item_name|
  item = Item.find_by_name(item_name)
  attribute_text = item.send(attribute).to_s
  response.should have_selector("img", :src => attribute_text)
end

Given /^"([^">]*) > ([^">]*) > ([^">]*)" item"?$/ do |item_type_name, item_sub_type_name, item_name|
  item_type = ItemType.find_or_create_by_name(item_type_name)
  item_sub_type = ItemSubType.create!(:name => item_sub_type_name, :item_type => item_type)
  @item = Item.create!(:name => item_name,
                       :item_sub_type => item_sub_type,
                       :price => item_name.length/100.0,
                       :summary => "Fabuleux #{item_name}",
                       :image => "http://www.photofabric.com/#{item_name}")
end

Then /^new items should have been inserted$/ do
  Item.maximum(:created_at).should >(@previous_item_insertion_time)
end
Then /^no new item should have been inserted$/ do
  Item.maximum(:created_at).should ==(@previous_item_insertion_time)
end

Then /^some items should have been modified$/ do
  Item.maximum(:updated_at).should >(@previous_item_modification_time)
end
Then /^no item should have been modified$/ do
  Item.maximum(:updated_at).should ==(@previous_item_modification_time)
end

Then /^no item should have been deleted$/ do
  Item.count.should ==(@previous_item_count)
end
