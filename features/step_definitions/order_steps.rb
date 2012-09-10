# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

Given /^an old order on "(.*)" with$/ do |store_name, table|
  cart = Cart.create
  table.hashes.each do |row|
    quantity = row["Quantity"].to_i
    item = Item.find_by_name(row["Item"])

    line = CartLine.create(cart: cart, quantity: quantity, item: item)
  end

  store = Store.find_by_url(MesCourses::Stores::Items::RealDummy.uri(store_name))
  order = Order.create(store: store, cart: cart, status: Order::SUCCEEDED)
end

