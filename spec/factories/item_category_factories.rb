# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau

FactoryGirl.define do

  sequence :category_name do |n|
    "Category-#{n}"
  end

  factory :item_category do |category|
    category.name { FactoryGirl.generate(:category_name) }
  end

  sequence :sub_category_name do |n|
    "SubCategory-#{n}"
  end

  factory :item_sub_category, :class => ItemCategory do |category|
    category.name { FactoryGirl.generate(:sub_category_name) }
    category.parent { |a| a.association(:item_category) }
  end

end
