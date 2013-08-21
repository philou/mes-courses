# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

CAPTURE_PERCENTAGE = Transform(/^\d+%$/) do |digits|
  digits.to_f
end

CAPTURE_STORE_NAME = Transform(/^(a|the) ?"?([^" ]*)"? store$/) do |_prefix, store_name|
  if store_name == ""
    main_store_name
  else
    register_store_name(store_name)
    store_name
  end
end

CAPTURE_DISH_NAME = Transform(/^(a|the|this) dish( "([^"]*)")?$/) do |_prefix, _quoted_dish_name, dish_name|
  if dish_name.nil?
    main_dish_name
  else
    register_dish_name(dish_name)
    dish_name
  end
end

CAPTURE_AMOUNT = Transform(/^(\d+(\.\d+)?)€$/) do |whole, _fraction|
  whole.to_f
end
