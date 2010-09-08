Given /^"([^">]*) > ([^"]*)" item sub type$/ do |type, sub_type|
  item_type = ItemType.find_or_create_by_name(type)
  @item_sub_type = ItemSubType.create!(:name => sub_type, :item_type => item_type)
end
