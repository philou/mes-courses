# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "cart/show.html.erb" do

  before(:each) do
    @tomates = stub(CartItem, :name => "Tomates", :price => 2.4, :quantity => 7)
    @pdt = stub(CartItem, :name => "Pommes de terre", :price => 0.99, :quantity => 1)
    @total_price = @tomates.price + @pdt.price
    @cart = stub(Cart, :items => [@tomates, @pdt], :total_price => @total_price)
    assigns[:cart] = @cart

    @stores = [stub_model(Store, :url => "http://www.auchandirect.fr"),
               stub_model(Store, :url => "http://www.mon-marche.fr")]
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


  it "displays a store forwarding forms" do
    @stores.each do |store|
      response.should have_xpath("//div[span[@class=\"section-title\"]=\"#{store.url}\"]/form",
                                 :action => default_path(:controller => 'cart', :action => 'forward_to_store', :id => store.id))
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

