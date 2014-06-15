# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
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

describe "dishes/new" do

  before :each do
    @dish = Dish.new(:name => "Nouvelle recette")
    assign :dish, @dish
  end

  it "should display a default name for the new dish" do
    render

    expect(rendered).to have_xpath('//form[@id="dish"]//input[@name="dish[name]"][@type="text"][@value="'+@dish.name+'"]')
  end

  it "should have a dish creation form" do
    render

    expect(rendered).to have_xpath('//form[@id="dish"][@method="post"][@action="'+url_for(:controller => 'dishes', :action => 'create')+'"]')
    expect(rendered).to have_xpath('//form[@id="dish"]//input[@type="submit"]')
  end

end
