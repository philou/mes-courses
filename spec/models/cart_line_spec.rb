# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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


require 'spec_helper'

describe CartLine do

  before(:each) do
    @item = stub_model(Item, :long_name => "Bavette", :price => 4.5)
    @cart_line = CartLine.new(:quantity => 1, :item => @item)
  end

  context "when created" do
    it "should have the price of its item" do
      expect(@cart_line.price).to eq @item.price
    end

    it "should have its item's long name" do
      expect(@cart_line.name).to eq @item.long_name
    end
  end

  it "should have the price of its item multiplied by its quantity" do
    5.times do
      expect(@cart_line.price).to eq @item.price * @cart_line.quantity
      @cart_line.increment_quantity
    end
  end

  it "should add its items to the online cart when forwarded" do
    @cart_line.increment_quantity

    store_api = double(MesCourses::Stores::Carts::Api)
    expect(store_api).to receive(:add_to_cart).once.with(@cart_line.quantity, @item)

    @cart_line.forward_to(store_api)
  end

end
