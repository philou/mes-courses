# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013, 2014 by Philippe Bourgau

FactoryGirl.define do

  sequence :item_name do |n|
    "Item-#{n}"
  end
  sequence :remote_id do |n|
    n.to_s
  end

  sequence :price do |n|
    (n.to_f / 100 + 1.0).to_f
  end

  factory :item do
    name { FactoryGirl.generate(:item_name) }
    brand { |a| "#{a.name} Corp." }
    image { |a| "http://www.image.org/#{a.name}" }
    remote_id { FactoryGirl.generate(:remote_id) }
    price { FactoryGirl.generate(:price) }

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
