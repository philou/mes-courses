# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

Given /^there is an? "([^">]*) > ([^">]*) > ([^">]*)" item"?$/ do |category_name, sub_category_name, item_name|
  @item = categorized_item(category_name, sub_category_name, :name => item_name)
  @item.remote_id = @item.id
  @item.save!
end
Given /^there is an? "([^">]*) > ([^">]*) > ([^">]*)" item at ([0-9\.]+)€"?$/ do |category_name, sub_category_name, item_name, price|
  @item = categorized_item(category_name, sub_category_name, :name => item_name, :price => price.to_f)
  @item.remote_id = @item.id
  @item.save!
end

Then /^there should (\d+) items with name "([^"]*)""? for sale$/ do |count, name|
  Item.count(:conditions => {:name => name}).should == count.to_i
end

Then /^all items should be organized by type and subtype$/ do
  Item.find(:all).each do |item|
    item.item_category.should_not be_nil
    item.item_category.parent.should_not be_nil
  end
end

Then /^all items should have an? (.*)$/ do |attribute|
  items = Item.all
  items.should all_do have_non_nil(attribute)
end

Then /^most items should have an? (.*)$/ do |attribute|
  Item.find(:all).should mostly have_non_nil(attribute)
end

Then /^I should see the "([^"]*)" of "([^"]*)"$/ do |attribute, item_name|
  item = Item.find_by_name(item_name)
  attribute_text = item.send(attribute).to_s
  page.should have_content(attribute_text)
end

Then /^I should see the "([^"]*)" of "([^"]*)" as img$/ do |attribute, item_name|
  item = Item.find_by_name(item_name)
  attribute_text = item.send(attribute).to_s
  page.should have_selector("img", :src => attribute_text)
end

Then /^new items should have been inserted$/ do
  Item.maximum(:created_at).should > Item.past_metrics[:created_at]
end
Then /^no new item should have been inserted$/ do
  Item.maximum(:created_at).should == Item.past_metrics[:created_at]
end

Then /^some items should have been modified$/ do
  Item.maximum(:updated_at).should > Item.past_metrics[:updated_at]
end
Then /^no item should have been modified$/ do
  Item.maximum(:updated_at).should == Item.past_metrics[:updated_at]
end

Then /^some items should have been deleted$/ do
  Item.count.should < Item.past_metrics[:count]
end
Then /^no item should have been deleted$/ do
  Item.count.should == Item.past_metrics[:count]
end

Then /^existing items should not have been modified$/ do
  Item.past_metrics[:all].each do |item|
    item.reload
    item.updated_at.should <= Item.past_metrics[:updated_at]
  end
end

Then /^item organization should not have changed$/ do
  ItemCategory.current_metrics.should == ItemCategory.past_metrics
end

Then /^item organization should have shrank$/ do
  ItemCategory.current_metrics[:count].should < ItemCategory.past_metrics[:count]
end

def i_should_see_an_item(name)
  page.should have_selector("div", :id => "items-panel") do |div|
    div.should have_content(item_name)
  end
end

Then /^I should see an? "([^"]*)" item"?$/ do |item_name|
  i_should_see_an_item(item_name)
end

Then /^I should not see an? "([^"]*)" item"?$/ do |item_name|
  page.should have_selector("div", :id => "items-panel") do |div|
    div.should_not have_content(item_name)
  end
end

def item_should_be_disabled(item)
  page.should have_selector("div", :id => "items-panel") do |div|
    div.should have_xpath(".//tr[contains(/td,'#{item}')]") do |tr|
      tr.should have_xpath(".//img[@src='disabled.png']")
      tr.should have_xpath(".//input[@type='submit'][@disabled='disabled']")
    end
  end
end

Then /^the following items should be disabled$/ do |table|
  pending

  table.each_item do |category, sub_category, item|
    visit item_categories_path
    click_link(category)
    click_link(sub_category)
    i_should_see_an_item(item)
    item_should_be_disabled(item)
  end
end
