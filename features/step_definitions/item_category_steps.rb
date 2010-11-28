Given /^"([^"]*)" item category"?$/ do |name|
  ItemCategory.create!(:name => name)
end

Given /^"([^">]*) > ([^"]*)" item sub category$/ do |type, category|
  item_category = ItemCategory.find_or_create_by_name_and_parent_id(type, nil)
  ItemCategory.create!(:name => category, :parent => item_category)
end
