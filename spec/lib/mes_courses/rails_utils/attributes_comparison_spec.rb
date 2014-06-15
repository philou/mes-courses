# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012, 2013 by Philippe Bourgau
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
require 'mes_courses/rails_utils/attributes_comparison'

describe "ActiveRecord attributes comparison" do

  before(:each) do
    @item_attributes = FactoryGirl.attributes_for :item
    @item = Item.new(@item_attributes)
    @item_category_attributes = FactoryGirl.attributes_for :item_category
    @item_category = ItemCategory.new(@item_category_attributes)
    @another_item_category = FactoryGirl.build :item_category
  end

  it "equals initial attributes" do
    expect(@item).to be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with another price" do
    @item_attributes[:price] += 2.3
    expect(@item).not_to be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with another brand" do
    @item_attributes[:brand] = @item_attributes[:brand] + " poids net 250g"
    expect(@item).not_to be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with an extra value" do
    @item_attributes[:unknown] = "Super promo"
    expect(@item).not_to be_equal_to_attributes(@item_attributes)
  end

  it "equals attributes with a belongs_to association" do
    @item_category_attributes[:parent] = @another_item_category
    @item_category.parent = @another_item_category
    expect(@item_category).to be_equal_to_attributes(@item_category_attributes)
  end

  it "does not equal attributes with a different belongs_to association" do
    @item_category_attributes[:parent] = @another_item_category
    expect(@item_category).not_to be_equal_to_attributes(@item_category_attributes)
  end

  it "equals attributes with a habtm association" do
    @item.item_categories.push(@item_category)
    @item_attributes[:item_categories] = [@item_category]
    expect(@item).to be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with a different habtm association" do
    @item_attributes[:item_category] = [@item_category]
    expect(@item).not_to be_equal_to_attributes(@item_attributes)
  end

end
