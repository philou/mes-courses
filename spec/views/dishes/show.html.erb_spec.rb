# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


require 'spec_helper'

describe "dishes/show" do
  include ApplicationHelper

  before :each do
    @dish = stub_model(Dish)
    @dish.stub(:items).and_return([FactoryGirl.build_stubbed(:item_with_categories),FactoryGirl.build_stubbed(:item_with_categories)])
    assign :dish, @dish
    assign :can_modify_dishes, false
  end


  it "should display brand, image and name of the items of the dish" do
    render

    @dish.items.each do |item|
      expect(rendered).to have_selector('img', :src => https_url(item.image))
      expect(rendered).to contain(item.name)
      expect(rendered).to contain(item.brand)
    end
  end

  context "adding items to the dish" do
    it "is forbidden by default" do
      render

      expect(rendered).not_to contain("Ajouter un ingrédient")
    end

    it "can be allowed" do
      assign :can_modify_dishes, true

      render

      expect(rendered).to contain("Ajouter un ingrédient")
      expect(rendered).to have_selector("a", :href => dish_item_categories_path(@dish))
    end
  end

  context "removing items from the dish" do

    it "is forbidden by default" do
      render

      expect(rendered).not_to contain("Enlever de la recette")
    end

    it "can be allowed" do
      assign :can_modify_dishes, true

      render

      @dish.items.each do |item|
        expect(rendered).to have_button_to("Enlever de la recette", dish_item_path(@dish, item), 'delete')
      end
    end
  end

end
