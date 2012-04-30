# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

Factory.sequence :item_name do |n|
  "Item-#{n}"
end
Factory.sequence :remote_id do |n|
  "#{n}"
end

Factory.define :item do |item|
  item.name { Factory.next(:item_name) }
  item.item_category { |a| a.association(:item_sub_category) }
  item.price { |a| a.name.length.to_f / 100.0 + 1.0 }
  item.summary { |a| "Fabuleux #{a.name}" }
  item.image { |a| "http://www.photofabric.com/#{a.name}" }
  item.remote_id { Factory.next(:remote_id) }
end

# custom factory function with a named organization
def categorized_item (category_name, sub_category_name, options = {})
  category = ItemCategory.find_or_create_by_name_and_parent_id(category_name, ItemCategory.root.id)
  sub_category = ItemCategory.find_or_create_by_name_and_parent_id(sub_category_name, category.id)

  Factory.create(:item, {:item_category => sub_category }.merge(options))
end
