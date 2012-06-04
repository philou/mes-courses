# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

FactoryGirl.define do

  sequence :dish_name do |n|
    "Dish-#{n}"
  end

  factory :dish do
    name { FactoryGirl.generate(:dish_name) }

    after :create do |dish|
      FactoryGirl.create_list(:item, 2, dishes: [dish])
    end
  end

end
