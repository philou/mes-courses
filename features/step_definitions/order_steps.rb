# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

Given /^an old order on "(.*)" with$/ do |store_name, table|
  cart = Cart.create
  table.hashes.each do |row|
    quantity = row["Quantity"].to_i
    item = Item.find_by_name(row["Item"])

    line = CartLine.create(cart: cart, quantity: quantity, item: item)
  end

  store = Store.find_by_url(Storexplore::Testing::DummyStore.uri(store_name))
  order = Order.create(store: store, cart: cart, status: Order::SUCCEEDED)
end

Then /^there should be a warning about the unavailability of "(.*)" in "(.*)"$/ do |item_name, store_name|
  item = Item.find_by_name(item_name)
  within(".warning") do
    should have_content(Order.missing_cart_line_notice(item.long_name, store_name))
  end
end
