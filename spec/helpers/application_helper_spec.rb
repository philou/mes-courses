# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2013 by Philippe Bourgau

require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  it "should create a default item category path for the nil category" do
    root_category_path = url_for(:controller => "item_categories")

    any_item_category_path.should == root_category_path
    any_item_category_path(nil).should == root_category_path
    any_item_category_path(double(ItemCategory, :id => nil)).should == root_category_path
  end

  it "should create real item category path for the valid categories" do
    category = stub_model(ItemCategory, :id => 123)

    any_item_category_path(category).should == item_category_path(category)
  end

  it "should forward extra query params to item_category_path" do
    category = stub_model(ItemCategory, :id => 123)
    query = [category, { :search => { :keyword => "Bio"} } ]

    actual = any_item_category_path(*query)
    actual.should == item_category_path(*query)

    # rails inside's self learning ...
    actual.should_not == item_category_path(category)
  end

  it "'s meta_http_equiv_refresh_tag calls @refresh_strategy.to_html" do
    @refresh_strategy = MesCourses::HtmlUtils::PageRefreshStrategy.new
    meta_http_equiv_refresh_tag.should == @refresh_strategy.to_html
  end

  it "'s meta_http_equiv_refresh_tag defaults to no refresh strategy" do
    meta_http_equiv_refresh_tag.should == MesCourses::HtmlUtils::PageRefreshStrategy.none.to_html
  end

end
