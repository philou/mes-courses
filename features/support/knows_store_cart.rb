# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'cucumber/rspec/doubles'

module KnowsStoreCart

  def cart_api
    @cart_api ||= MesCourses::Stores::Carts::DummyApi.new
  end

  def given_the_store(store_name)
    MesCourses::Stores::Carts::DummyApi.stub(:login) do |login,password|
      cart_api.relog(login, password)
      cart_api
    end

    create_new_store("http://"+store_name)
  end

  def given_an_item_is_unavailable_in_the_store(item_name)
    item = Item.find_by_name(item_name)
    throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

    cart_api.add_unavailable_item(item.remote_id)
  end

  def then_an_empty_cart_should_be_created_in_the_store_account_of_the_user
    cart_api.log.should include(:empty_the_cart)
  end

  def then_a_non_empty_cart_should_be_created_in_the_store_account_of_the_user
    cart_api.log.should include(:add_to_cart)
  end

end
World(KnowsStoreCart)
