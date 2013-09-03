# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

CAPTURE_PERCENTAGE = Transform(/^\d+%$/) do |digits|
  digits.to_f
end

CAPTURE_STORE_NAME = NameOrPronounTransform('store', 'www.dummy-store.com')
CAPTURE_DISH_NAME = NameOrPronounTransform('dish', 'Pizza pommes de terre')
CAPTURE_ITEM_NAME = NameOrPronounTransform('item', 'Patates')
CAPTURE_EMAIL = NameOrPronounTransform('email', 'joe@mail.com')

CAPTURE_AMOUNT = Transform(/^(\d+(\.\d+)?)€$/) do |whole, _fraction|
  whole.to_f
end
