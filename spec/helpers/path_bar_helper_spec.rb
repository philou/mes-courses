# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe PathBarHelper do
  include PathBarHelper

  it "should build path elements with no link" do
    expect(path_bar_element_with_no_link("Going nowhere")).to eq "Going nowhere"
  end

  it "matches elements with no link" do
    expect(path_bar_element_with_no_link?(path_bar_element_with_no_link("anything"))).to eq true
    expect(path_bar_element_with_no_link?(path_bar_element_for_current_resource("anything"))).to eq false
  end

  it "should build path elements for current resource" do
    expect(path_bar_element_for_current_resource("You are here")).to eq ["You are here"]
  end

  it "should build path elements with explicit links" do
    expect(path_bar_element("Somewhere", :controller => "dispatcher")).to eq ["Somewhere", {:controller => "dispatcher"}]
  end

end
