# Copyright (C) 2010 by Philippe Bourgau

Given /^"([^ ]*) au ([^"]*)" is a known dish"?$/ do |item1, item2|

  misc_category = ItemCategory.find_or_create_by_name_and_parent_id("Divers",nil)
  misc_sub_category = ItemCategory.find_or_create_by_name_and_parent_id("Divers", misc_category.id)

  items = [item1,item2].map do |item|
    Item.create!(:name => item, :price => item.length.to_f, :item_category => misc_sub_category)
  end

  @known_dish = Dish.create!(:name => item1+" au "+item2, :items => items)
end
