# -*- encoding: utf-8 -*-
# Copyright (C) 2013, 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


require 'cucumber/rspec/doubles'

module KnowsStoreCart

  def cart_api
    @cart_api ||= Auchandirect::ScrAPI::DummyCart.new
  end

  def given_the_store(store_name)
    Auchandirect::ScrAPI::DummyCart.stub(:login) do |login,password|
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
    expect(cart_api.log).to include(:empty_the_cart)
  end

  def then_a_non_empty_cart_should_be_created_in_the_store_account_of_the_user
    expect(cart_api.log).to include(:add_to_cart)
  end

end
World(KnowsStoreCart)
