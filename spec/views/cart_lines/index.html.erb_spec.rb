# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "cart_lines/index" do
  include ApplicationHelper

  before(:each) do
    @tomates = stub_model(CartLine, :name => "Tomates", :price => 2.4, :quantity => 7)
    @pdt = stub_model(CartLine, :name => "Pommes de terre", :price => 0.99, :quantity => 1)
    @total_price = @tomates.price + @pdt.price
    @cart = stub_model(Cart, :total_price => @total_price)
    @cart.lines.push(@tomates)
    @cart.lines.push(@pdt)
    assign :cart, @cart

    @stores = [stub_model(Store, :url => "http://www.auchandirect.fr", :name => "www.auchandirect.fr"),
               stub_model(Store, :url => "http://www.mon-marche.fr", :name => "www.mon-marche.fr")]
    assign :stores, @stores

    render
  end

  it "renders items in an html table" do
    expect(rendered).to have_selector("table")
  end

  it "displays the first item" do
    expect(rendered).to contain(@tomates.name)
  end

  it "displays the second item" do
    expect(rendered).to contain(@pdt.name)
  end

  it "displays the price of each item" do
    expect(rendered).to contain("#{@tomates.price}€")
  end

  it "displays the total price" do
    expect(rendered).to contain("#{@total_price}€")
  end

  it "displays the quantity of each item" do
    expect(rendered).to contain(@tomates.quantity.to_s)
  end

  it "should have a button to empty the cart" do
    expect(rendered).to have_button_to("Vider le panier", destroy_all_cart_lines_path, 'delete')
  end

  it "displays store forwarding forms" do
    @stores.each do |store|
      expect(rendered).to have_xpath("//div[contains(span[@class=\"section-title\"], \"#{store.name}\")]/form" +
                                 "[starts-with(@action, '#{url_for(:controller => 'orders', :action => 'create')}')]" +
                                 "[contains(@action, 'store_id=#{store.id}')]" +
                                 "[contains(@action, 'cart_id=#{@cart.id}')]")
    end
  end

  it "displays a login input" do
    expect(rendered).to have_xpath('//form[@class="store-login"]//input[@name="store[login]"]')
  end
  it "displays a password input" do
    expect(rendered).to have_xpath('//form[@class="store-login"]//input[@name="store[password]"]')
  end
  it "displays a forward button" do
    expect(rendered).to have_xpath('//form[@class="store-login"]//input[@type="submit"]')
  end

end

