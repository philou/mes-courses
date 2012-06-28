# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

FactoryGirl.define do

  sequence :dish_name do |n|
    "Dish-#{n}"
  end

  factory :dish do
    name { FactoryGirl.generate(:dish_name) }

    factory :dish_with_items do
      after :create do |dish|
        dish.items = FactoryGirl.create_list(:item_with_categories, 2, dishes: [dish])
      end
    end
  end

end
