# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "dishes/new" do

  before :each do
    @dish = Dish.new(:name => "Nouvelle recette")
    assign :dish, @dish
  end

  it "should display a default name for the new dish" do
    render

    rendered.should have_xpath('//form[@id="dish"]//input[@name="dish[name]"][@type="text"][@value="'+@dish.name+'"]')
  end

  it "should have a dish creation form" do
    render

    rendered.should have_xpath('//form[@id="dish"][@method="post"][@action="'+url_for(:controller => 'dishes', :action => 'create')+'"]')
    rendered.should have_xpath('//form[@id="dish"]//input[@type="submit"]')
  end

end
