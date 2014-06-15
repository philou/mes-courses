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

describe "cart_lines/index" do
  include ApplicationHelper
  include KnowsPageParts

  before(:each) do
    assign :cart, @cart = FactoryGirl.create(:cart)
    buy_an_item(7)
    buy_an_item

    buy_a_dish
    buy_a_dish

    assign :stores, [@store = FactoryGirl.create(:store)]
    render
  end

  def buy_an_item(count = 1, item = FactoryGirl.create(:item))
    7.times do
      @cart.add_item(item)
    end
  end

  def buy_a_dish(dish = FactoryGirl.create(:dish))
    @cart.add_dish(dish)
  end


  context "item lines" do

    it "displays each item" do
      @cart.lines.each do |line|
        expect(rendered).to contain_a(cart_line_with_long_name(line.name))
      end
    end

    it "displays the price of each item" do
      @cart.lines.each do |line|
        expect(rendered).to contain_a(cart_line_with_long_name_and_price(line.name, line.price))
      end
    end

    it "displays the quantity of each item" do
      @cart.lines.each do |line|
        expect(rendered).to contain_a(cart_line_with_long_name_and_quantity(line.name, line.quantity.to_s))
      end
    end

    it "displays the total price" do
      expect(rendered).to contain_the(cart_total(@cart.total_price))
    end

    it "should have a button to empty the cart" do
      expect(rendered).to have_button_to("Vider le panier", destroy_all_cart_lines_path, 'delete')
    end

  end

  context "dish reminder" do

    it "displays each dish" do
      @cart.dishes.each do |dish|
        expect(rendered).to contain_a(dish_with_name(dish.name))
      end
    end
  end

  context "store forwarding" do

    it 'logs the client out before the transfer' do
      iframe_id = remote_store_iframe_id(@store)
      expect(rendered).to have_xpath("//iframe[@class='remote-store-iframe' and @src='#{@store.logout_url}' and @name='#{iframe_id}' and @id='#{iframe_id}']")
    end

    it "displays one forwarding form for every store" do
      assign :stores, stores = FactoryGirl.create_list(:store, 2)
      render

      stores.each do |store|
        expect(rendered).to have_xpath(forwarding_form_xpath(store))
      end
    end

    it "logs the client into the store at the beginning of the transfer" do
      expect(rendered).to have_xpath(forwarding_form_xpath(@store) +
                                     "[@action='#{@store.login_url}' and @target='#{remote_store_iframe_id(@store)}']")
    end

    it "starts the actual transfer through ajax" do
      expect(rendered).to have_xpath(forwarding_form_xpath(@store) +
                                     "[@ajax-action='#{url_for(controller: 'orders', action: 'create', store_id: @store.id, cart_id: @cart.id)}']")
    end

    Auchandirect::ScrAPI::DummyCart.login_parameters('','').each do |parameter|
      param_name = parameter['name']
      it "'s forwarding store has the store required parameter '#{param_name}'" do
        expect(rendered).to have_xpath("//form[@class=\"store-login\"]//input[@name=\"#{param_name}\"]")
      end
    end

    it "displays a forward button" do
      expect(rendered).to have_xpath('//form[@class="store-login"]//input[@type="submit"]')
    end

    def remote_store_iframe_id(store)
      "remote-store-iframe-#{store.id}"
    end
    def forwarding_form_xpath(store)
      "//div[contains(span[@class=\"section-title\"], \"#{store.name}\")]/form"
    end
  end

end

