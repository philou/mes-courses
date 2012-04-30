# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

Factory.sequence :category_name do |n|
  "Category-#{n}"
end

Factory.define :item_category do |category|
  category.name { Factory.next(:category_name) }
end

Factory.sequence :sub_category_name do |n|
  "SubCategory-#{n}"
end

Factory.define :item_sub_category, :class => ItemCategory do |category|
  category.name { Factory.next(:sub_category_name) }
  category.parent { |a| a.association(:item_category) }
end
