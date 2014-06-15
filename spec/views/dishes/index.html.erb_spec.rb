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
