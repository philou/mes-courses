# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "/dishes/show.html.erb" do

  before :each do
    items = [Factory.create(:item), Factory.create(:item)]
    assigns[:dish] = @dish = stub_model(Dish, :items => items)
    assigns[:can_modify_dishes] = false
  end


  it "should display image, name and summary of the items of the dish" do
    render

    @dish.items.each do |item|
      response.should have_selector('img', :src => item.image)
      response.should contain(item.name)
      response.should contain(item.summary)
    end
  end

  context "adding items to the dish" do
    it "is forbidden by default" do
      render

      response.should_not contain("Ajouter un ingrédient")
    end

    it "can be allowed" do
      assigns[:can_modify_dishes] = true

      render

      response.should contain("Ajouter un ingrédient")
      response.should have_selector("a", :href => dish_item_categories_path(@dish))
    end
  end

  context "removing items from the dish" do

    it "is forbidden by default" do
      render

      response.should_not contain("Enlever de la recette")
    end

    it "can be allowed" do
      assigns[:can_modify_dishes] = true

      render

      @dish.items.each do |item|
        response.should have_button_to("Enlever de la recette", dish_item_path(@dish, item), 'delete')
      end
    end
  end

end
