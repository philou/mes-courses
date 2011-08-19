# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe "layouts/application.html.erb" do
  include PathBarHelper

  it "should render flash[:notice]" do
    assigns[:path_bar] = []
    flash[:notice] = notice = "Something went bad ..."
    render
    response.should contain notice
  end

  it "should render the link in a @path_bar element" do
    text = "Promotions !"
    controller = "cart_lines"
    assigns[:path_bar] = path_bar = [path_bar_element(text, :controller => controller)]
    render
    response.should have_xpath("//div[@id='path-bar']/a[@href='/#{controller}'][text()='#{text}']")
  end

  it "should render an empty @path_bar" do
    assigns[:path_bar] = path_bar = []
    render
  end

  it "should render a @path_bar element with no link" do
    text = "Recettes"
    assigns[:path_bar] = path_bar = [path_bar_element_with_no_link(text)]
    render
    response.should have_xpath("//div[@id='path-bar']/a[not(@href)][text()='#{text}']")
  end

  it "should display nicely a @path_bar with many elements" do
    assigns[:path_bar] = path_bar = [path_bar_element_with_no_link("Ingrédients"),
                                     path_bar_element_with_no_link("Marché"),
                                     path_bar_element_with_no_link("Poisson")]
    render
    response.should contain "Ingrédients > Marché > Poisson"
  end

end

