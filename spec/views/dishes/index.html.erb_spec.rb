# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe "dishes/index" do
  include KnowsPageParts

  before(:each) do
    assign :dishes, @dishes = FactoryGirl.create_list(:dish, 2)
    assign :can_modify_dishes, false
  end

  it "should display the name of each dish" do
    render
    @dishes.each {|dish| expect(rendered).to contain(dish.name) }
  end

  it "should display a link to add all the items of a dish to the cart" do
    render
    @dishes.each do |dish|
      expect(rendered).to have_button_to("Ajouter au panier", add_dish_to_cart_lines_path(:id => dish.id), 'post')
    end
  end

  it "displays disabled dishes accordingly" do
    dish = @dishes.first.disable

    render

    expect(rendered).to contain_a(disabled_dish_with_name(dish.name))
  end

  it "should display a link to the details of each dish" do
    render

    @dishes.each do |dish|
      expect(rendered).to have_selector("a", :href => dish_path(dish))
    end
  end

  context "adding a new dish" do

    it "is forbidden by default" do
      render

      expect(rendered).not_to have_selector("a", :href => new_dish_path)
    end

    it "can be allowed" do
      assign :can_modify_dishes, true

      render

      expect(rendered).to have_selector("a", :href => new_dish_path)
    end

  end

end
