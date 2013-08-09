# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

class String
  def occurences_of(substring)
    before, match, after = partition(substring)
    if !after.empty?
      after.occurences_of(substring) + 1
    elsif !match.empty?
      1
    else
      0
    end
  end
end

shared_examples_for "any layout" do
  include PathBarHelper

  before :each do
    assign :path_bar, []
    assign :session_place_text, "Connection"
    assign :session_place_url, "/sessions"
    assign :app_part, "whatever"
  end

  it "should render flash[:notice]" do
    flash[:notice] = notice = "Something went bad ..."
    render
    expect(rendered).to contain notice
  end

  it "should render flash[:alert]" do
    flash[:alert] = alert = "Something went really bad ..."
    render
    expect(rendered).to contain alert
  end

  it "should render the link in a @path_bar element" do
    text = "Promotions !"
    controller = "cart_lines"
    assign :path_bar, path_bar = [path_bar_element(text, :controller => controller)]
    render
    expect(rendered).to have_xpath("//div[@id='path-bar']/a[@href='/#{controller}'][text()='#{text}']")
  end

  it "should render an empty @path_bar" do
    assign :path_bar, path_bar = []
    render
  end

  it "should render a @path_bar element with no link" do
    text = "Recettes"
    assign :path_bar, path_bar = [path_bar_element_with_no_link(text)]
    render
    expect(rendered).to have_xpath("//div[@id='path-bar']/a[not(@href)][text()='#{text}']")
  end

  it "should display nicely a @path_bar with many elements" do
    assign :path_bar, path_bar = [path_bar_element_with_no_link("Ingrédients"),
                                     path_bar_element_with_no_link("Marché"),
                                     path_bar_element_with_no_link("Poisson")]
    render
    expect(rendered).to contain "Ingrédients > Marché > Poisson"
  end

  it "should not auto refresh by default" do
    render

    expect(rendered).not_to have_xpath("//meta[@http-equiv='refresh']")
  end

  it "should auto refresh if @refresh_strategy is assigned" do
    assign :refresh_strategy, refresh_strategy = MesCourses::HtmlUtils::PageRefreshStrategy.new

    render

    expect(rendered).to have_xpath("//meta[@http-equiv='refresh']")
    expect(rendered).to include(refresh_strategy.to_html)
  end

  it "should display the assigned session place" do
    text = assign :session_place_text, "Sign in"
    url = assign :session_place_url, "/sign_in_now"

    render

    expect(rendered).to have_place(text: text, url: url)
  end

  it "should render the inner content" do
    content = "unique content"

    render text: content, layout: "layouts/application.html"

    expect(rendered.occurences_of(content)).to eq 1
  end

  it "should include the css of the corresponding app part" do
    assign :app_part, app_part = "best"

    render

    expect(rendered).to include "best.css"
  end

  it 'does not include google analytics by default' do
    expect(ENV['GOOGLE_ANALYTICS_ENABLED']).not_to equal('true')

    render

    expect(rendered).not_to include 'analytics.js'
  end

  it 'includes google analytics with GOOGLE_ANALYTICS_ENABLED' do
    expect(ENV['GOOGLE_ANALYTICS_ENABLED']).not_to equal('true')

    begin
      ENV['GOOGLE_ANALYTICS_ENABLED'] = 'true'

      render

      expect(rendered).to include 'analytics.js'
    ensure
      ENV.delete('GOOGLE_ANALYTICS_ENABLED')
    end
  end

end
