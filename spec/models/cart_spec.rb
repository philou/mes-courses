# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013, 2014 by Philippe Bourgau
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

describe Cart do

  before(:each) do
    @bavette = FactoryGirl.create(:item)
    @cart = FactoryGirl.create(:cart)

    @items = FactoryGirl.create_list(:item, 5)
  end

  it "should be empty when created" do
    expect(@cart).to be_empty
  end

  it "should have no items when created" do
    expect(@cart.lines).to be_empty
  end

  it "should not be empty once items were added" do
    @cart.add_item(@bavette)
    expect(@cart).not_to be_empty
  end

  it "should contain added items" do
    fill_the_cart

    cart_should_contain_all(@items)
  end

  describe "adding a dish" do

    before :each do
      @cart.add_dish(@dish = FactoryGirl.create(:dish_with_items))
    end

    it "notes added dishes" do
      expect(@cart.dishes).to include(@dish)
    end

    it "contains items from added dishes" do
      cart_should_contain_all(@dish.items)
    end

    it "forgets about dishes when emptied" do
      @cart.empty

      expect(@cart.dishes).to be_empty
    end

  end


  it "should have a total price of 0 when empty" do
    expect(@cart.total_price).to eq 0
  end

  it "should have a total price of its item" do
    @cart.add_item(@bavette)
    expect(@cart.total_price).to eq @bavette.price
  end

  it "should have a total price equal to the sum of the prices of all its items" do
    fill_the_cart

    items_amount = (@items.map &:price).inject &:+
    expect(@cart.total_price).to eq items_amount
  end

  it "should remove all items when emptied" do
    @cart.add_item(@bavette)

    @cart.empty

    expect(@cart).to be_empty
  end

  context "when the same item was added twice" do

    before(:each) do
      @cart.add_item(@bavette)
    end

    it "should have only one cart item" do
      @cart.add_item(@bavette)
      expect(@cart.lines).to have(1).entry
    end

    it "should have a cart item with quantity 2" do
      expect(@cart.lines.first).to receive(:increment_quantity)
      @cart.add_item(@bavette)
    end
  end

  context "when forwarding to an online store" do

    before :each do
      @order = FactoryGirl.create(:order)
      @cart = @order.cart

      @store_api = Auchandirect::ScrAPI::DummyCart.new
    end

    it "should empty the remote cart first" do
      @store_api.add_to_cart(1, 1)

      forward_to_store

      expect(@store_api).to be_empty
    end

    it "should forward its lines" do
      fill_the_cart

      forward_to_store

      @cart.lines.each do |line|
        expect(@store_api).to be_containing(line.item.remote_id, line.quantity)
      end
    end

    it "should not report warning without reason" do
      fill_the_cart

      forward_to_store

      expect(@order.warning_notices).to be_empty
    end

    it "should report missing items warnings" do
      fill_the_cart
      missing_lines = some_cart_lines_are_missing

      forward_to_store

      expect(@order.warning_notices).to have(missing_lines.count).items
    end

    it "should update the forwarded lines progress after each" do
      fill_the_cart

      forward_to_store

      expect(@order.forwarded_cart_lines_count).to eq @cart.lines.size
    end

    def forward_to_store
      @cart.forward_to(MesCourses::Stores::Carts::Session.new(@store_api), @order)
    end

    def some_cart_lines_are_missing
      missing_lines = @cart.lines[2..3]
      missing_lines.each do |line|
        @store_api.add_unavailable_item(line.item.remote_id)
      end
      missing_lines
    end
  end

  private

  def cart_should_contain_all(items)
    items.each do |added_item|
      cart_item = @cart.lines.detect {|line| line.item == added_item}
      expect(cart_item).not_to be_nil
    end
  end

  def fill_the_cart
    @items.each do |item|
      @cart.add_item(item)
    end
  end

end
