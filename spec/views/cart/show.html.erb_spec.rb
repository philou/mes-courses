# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "cart/show.html.erb" do

  before(:each) do
    assigns[:cart] = stub(Cart, :items => ["Tomates", "Pommes de terre"].map {|name| stub(Item, :name => name) } )
  end

  it "displays the first item" do
    render
    response.should contain("Tomates")
  end

  it "displays the second item" do
    render
    response.should contain("Pommes de terre")
  end

end

