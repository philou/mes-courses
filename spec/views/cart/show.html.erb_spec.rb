# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "cart/show.html.erb" do

  before(:each) do
    assigns[:cart] = stub(Cart, :items => ["Tomates", "Pommes de terre"].map {|name| stub(Item, :name => name) } )
    render
  end

  it "renders items in an html table" do
    # I had problems because of ill parsed .html.erb template
    response.should have_selector("table")
  end

  it "displays the first item" do
    response.should contain("Tomates")
  end

  it "displays the second item" do
    response.should contain("Pommes de terre")
  end

end

