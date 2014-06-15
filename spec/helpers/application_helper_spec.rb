# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2013 by Philippe Bourgau
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

describe ApplicationHelper do
  include ApplicationHelper

  it "knows the root item category path" do
    expect(root_item_category_path).to eq(item_category_path(ItemCategory.root))
  end

  it "should create a default item category path for the nil category" do
    expect(any_item_category_path).to eq root_item_category_path
    expect(any_item_category_path(nil)).to eq root_item_category_path
    expect(any_item_category_path(double(ItemCategory, :id => nil))).to eq root_item_category_path
  end

  it "should create real item category path for the valid categories" do
    category = FactoryGirl.create(:item_category)

    expect(any_item_category_path(category)).to eq item_category_path(category)
  end

  it "should forward extra query params to item_category_path" do
    category = FactoryGirl.create(:item_category)
    query = [category, { :search => { :keyword => "Bio"} } ]

    actual = any_item_category_path(*query)
    expect(actual).to eq item_category_path(*query)

    # rails inside's self learning ...
    expect(actual).not_to eq item_category_path(category)
  end

  it "'s meta_http_equiv_refresh_tag calls @refresh_strategy.to_html" do
    @refresh_strategy = MesCourses::HtmlUtils::PageRefreshStrategy.new
    expect(meta_http_equiv_refresh_tag).to eq @refresh_strategy.to_html
  end

  it "'s meta_http_equiv_refresh_tag defaults to no refresh strategy" do
    expect(meta_http_equiv_refresh_tag).to eq MesCourses::HtmlUtils::PageRefreshStrategy.none.to_html
  end

end
