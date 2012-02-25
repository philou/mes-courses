# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "cart_lines/index.html.erb" do
  include ApplicationHelper

  before(:each) do
    @tomates = stub_model(CartLine, :name => "Tomates", :price => 2.4, :quantity => 7)
    @pdt = stub_model(CartLine, :name => "Pommes de terre", :price => 0.99, :quantity => 1)
    @total_price = @tomates.price + @pdt.price
    @cart = stub_model(Cart, :lines => [@tomates, @pdt], :total_price => @total_price)
    assigns[:cart] = @cart

    @stores = [stub_model(Store, :url => "http://www.auchandirect.fr", :name => "www.auchandirect.fr"),
               stub_model(Store, :url => "http://www.mon-marche.fr", :name => "www.mon-marche.fr")]
    assigns[:stores] = @stores

    render
  end

  it "renders items in an html table" do
    response.should have_selector("table")
  end

  it "displays the first item" do
    response.should contain(@tomates.name)
  end

  it "displays the second item" do
    response.should contain(@pdt.name)
  end

  it "displays the price of each item" do
    response.should contain("#{@tomates.price}€")
  end

  it "displays the total price" do
    response.should contain("#{@total_price}€")
  end

  it "displays the quantity of each item" do
    response.should contain(@tomates.quantity.to_s)
  end

  it "should have a button to empty the cart" do
    response.should have_button_to("Vider le panier", destroy_all_cart_lines_path, 'delete')
  end

  it "displays a store forwarding forms" do
    @stores.each do |store|
      response.should have_xpath("//div[contains(span[@class=\"section-title\"], \"#{store.name}\")]/form" +
                                 "[starts-with(@action, '#{url_for(:controller => 'orders', :action => 'create')}')]" +
                                 "[contains(@action, 'store_id=#{store.id}')]" +
                                 "[contains(@action, 'cart_id=#{@cart.id}')]")
    end
  end

  it "displays a login input" do
    response.should have_xpath('//form[@class="store-login"]//input[@name="store[login]"]')
  end
  it "displays a password input" do
    response.should have_xpath('//form[@class="store-login"]//input[@name="store[password]"]')
  end
  it "displays a forward button" do
    response.should have_xpath('//form[@class="store-login"]//input[@type="submit"]')
  end

end

