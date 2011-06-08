# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "/dish/index.html.erb" do

  before(:each) do
    @dishes = ["Tomates farcies", "Pates au gruyère"].map {|name| stub_model(Dish, :name => name) }
    assigns[:dishes] = @dishes
  end

  it "should display the name of each dish" do
    render
    @dishes.each {|dish| response.should contain(dish.name) }
  end

  it "should display a link to add all the items of a dish to the cart" do
    render
    @dishes.each do |dish|
      response.should have_xpath("//form[@action='#{default_path(:controller => 'cart',:action => 'add_dish',:id => dish.id)}']")
    end
  end

  it "should display a link to the details of each dish" do
    render

    @dishes.each do |dish|
      response.should have_selector("a", :href => dish_path(dish))
    end
  end

  it "should display a link to add a new dish" do
    render
    response.should have_selector("a", :href => new_dish_path)
  end

end
