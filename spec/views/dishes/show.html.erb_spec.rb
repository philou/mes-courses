# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "dishes/show" do

  before :each do
    @dish = stub_model(Dish)
    @dish.stub(:items).and_return([FactoryGirl.create(:item),FactoryGirl.create(:item)])
    assign :dish, @dish
    assign :can_modify_dishes, false
  end


  it "should display image, name and summary of the items of the dish" do
    render

    @dish.items.each do |item|
      rendered.should have_selector('img', :src => item.image)
      rendered.should contain(item.name)
      rendered.should contain(item.summary)
    end
  end

  context "adding items to the dish" do
    it "is forbidden by default" do
      render

      rendered.should_not contain("Ajouter un ingrédient")
    end

    it "can be allowed" do
      assign :can_modify_dishes, true

      render

      rendered.should contain("Ajouter un ingrédient")
      rendered.should have_selector("a", :href => dish_item_categories_path(@dish))
    end
  end

  context "removing items from the dish" do

    it "is forbidden by default" do
      render

      rendered.should_not contain("Enlever de la recette")
    end

    it "can be allowed" do
      assign :can_modify_dishes, true

      render

      @dish.items.each do |item|
        rendered.should have_button_to("Enlever de la recette", dish_item_path(@dish, item), 'delete')
      end
    end
  end

end
