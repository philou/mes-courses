# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "/dish/show.html.erb" do

  before :each do
    items = [Factory.create(:item), Factory.create(:item)]
    assigns[:dish] = @dish = stub_model(Dish, :items => items)
  end


  it "should display image, name and summary of the items of the dish" do
    render

    @dish.items.each do |item|
      response.should have_selector('img', :src => item.image)
      response.should contain(item.name)
      response.should contain(item.summary)
    end
  end

  it "should display a link to add items to the dish" do
    render

    response.should contain("Ajouter un ingrédient")
    response.should have_selector("a", :href => dish_item_category_index_path(@dish))
  end

end