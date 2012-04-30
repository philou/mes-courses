# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "dishes/index" do

  before(:each) do
    @dishes = ["Tomates farcies", "Pates au gruyère"].map {|name| stub_model(Dish, :name => name) }
    assign :dishes, @dishes
    assign :can_modify_dishes, false
  end

  it "should display the name of each dish" do
    render
    @dishes.each {|dish| rendered.should contain(dish.name) }
  end

  it "should display a link to add all the items of a dish to the cart" do
    render
    @dishes.each do |dish|
      rendered.should have_button_to("Ajouter au panier", add_dish_to_cart_lines_path(:id => dish.id), 'post')
    end
  end

  it "should display a link to the details of each dish" do
    render

    @dishes.each do |dish|
      rendered.should have_selector("a", :href => dish_path(dish))
    end
  end

  context "adding a new dish" do

    it "is forbidden by default" do
      render

      rendered.should_not have_selector("a", :href => new_dish_path)
    end

    it "can be allowed" do
      assign :can_modify_dishes, true

      render

      rendered.should have_selector("a", :href => new_dish_path)
    end

  end

end
