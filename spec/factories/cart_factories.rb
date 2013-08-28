# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

FactoryGirl.define do

  factory :cart do
    trait :with_items do
      after :create do |cart|
        cart.lines = FactoryGirl.create_list(:cart_line, 2, cart: cart)
      end
    end
  end

end
