# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

FactoryGirl.define do

  sequence :item_name do |n|
    "Item-#{n}"
  end
  sequence :remote_id do |n|
    n.to_s
  end

  factory :item do
    name { FactoryGirl.generate(:item_name) }
    price { |a| (a.name.length.to_f / 100.0 + 1.0).to_f }
    brand { |a| "#{a.name} Inc." }
    image { |a| "http://www.photofabric.com/#{a.name}" }
    remote_id { FactoryGirl.generate(:remote_id) }

    factory :item_with_categories do
      after :create do |item|
        item.item_categories = FactoryGirl.create_list(:item_sub_category, 1, items: [item])
      end
    end
  end

end

# custom factory function with a named organization
def categorized_item (category_name, sub_category_name, options = {})
  category = ItemCategory.find_or_create_by_name_and_parent_id(category_name, ItemCategory.root.id)
  sub_category = ItemCategory.find_or_create_by_name_and_parent_id(sub_category_name, category.id)

  FactoryGirl.create(:item, {item_categories: [sub_category]}.merge(options))
end
