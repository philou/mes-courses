Given /^"([^"]*)" item type$/ do |name|
  @item_type = ItemType.create!(:name => name)
end
