# Copyright (C) 2010 by Philippe Bourgau

Given /^"([^ ]*) au ([^"]*)" is a known dish"?$/ do |item1, item2|

  # TODO simplify when merging ItemType and ItemSubType
  misc_item_type = ItemType.find_or_create_by_name("Divers")
  misc_item_sub_type = ItemSubType.find_or_create_by_name_and_item_type_id("Divers", misc_item_type.id)

  items = [item1,item2].map do |item|
    Item.create!(:name => item, :price => item.length.to_f, :item_sub_type => misc_item_sub_type)
  end

  @known_dish = Dish.create!(:name => item1+" au "+item2, :items => items)
end
