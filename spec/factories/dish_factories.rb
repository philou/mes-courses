# Copyright (C) 2011 by Philippe Bourgau

Factory.sequence :dish_name do |n|
  "Dish-#{n}"
end

Factory.define :dish do |dish|
  dish.name { Factory.next(:dish_name) }
  dish.items { [Factory.create(:item), Factory.create(:item)]}
end

