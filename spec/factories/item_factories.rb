# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

FactoryGirl.define do

  sequence :item_name do |n|
    "Item-#{n}"
  end
  sequence :remote_id do |n|
    "#{n}"
  end

  factory :item_attributes, class: Item do |item|
    item.name { FactoryGirl.generate(:item_name) }
    item.price { |a| a.name.length.to_f / 100.0 + 1.0 }
    item.summary { |a| "Fabuleux #{a.name}" }
    item.image { |a| "http://www.photofabric.com/#{a.name}" }
    item.remote_id { FactoryGirl.generate(:remote_id) }
  end

  factory :item, parent: :item_attributes do |item|
    item.item_category { |a| a.association(:item_sub_category) }
  end

end

# custom factory function with a named organization
def categorized_item (category_name, sub_category_name, options = {})
  category = ItemCategory.find_or_create_by_name_and_parent_id(category_name, ItemCategory.root.id)
  sub_category = ItemCategory.find_or_create_by_name_and_parent_id(sub_category_name, category.id)

  FactoryGirl.create(:item, {:item_category => sub_category }.merge(options))
end
