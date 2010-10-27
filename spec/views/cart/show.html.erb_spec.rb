# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "cart/show.html.erb" do

  before(:each) do
    @tomates = stub(CartItem, :name => "Tomates", :price => 2.4, :quantity => 1)
    @pdt = stub(CartItem, :name => "Pommes de terre", :price => 0.99, :quantity => 1)
    @total_price = @tomates.price + @pdt.price
    @cart = stub(Cart, :items => [@tomates, @pdt], :total_price => @total_price)
    assigns[:cart] = @cart
  end

  it "renders items in an html table" do
    render

    response.should have_selector("table")
  end

  it "displays the first item" do
    render

    response.should contain("Tomates")
  end

  it "displays the second item" do
    render

    response.should contain("Pommes de terre")
  end

  it "displays the price of each item" do
    render

    response.should contain("#{@tomates.price}€")
  end

  it "displays the total price" do
    render

    response.should contain("#{@total_price}€")
  end

  it "displays the quantity of each item" do
    @tomates.stub(:quantity).and_return(7)
    render

    response.should contain("7")
  end

end

