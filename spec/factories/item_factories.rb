# Copyright (C) 2010 by Philippe Bourgau

Factory.sequence :item_name do |n|
  "Item-#{n}"
end

Factory.define :item do |item|
  item.name { Factory.next(:item_name) }
  item.item_category { |a| a.association(:item_sub_category) }
  item.price { |a| a.name.length.to_f / 100.0 + 1.0 }
  item.summary { |a| "Fabuleux #{a.name}" }
  item.image { |a| "http://www.photofabric.com/#{a.name}" }
end

# custom factory function with a named organization
def categorized_item (category_name, sub_category_name, options = {})
  category = Factory.create(:item_category, :name => category_name)

  sub_category = Factory.create(:item_sub_category, :name => sub_category_name, :parent => category)

  Factory.create(:item, {:item_category => sub_category }.merge(options))
end
