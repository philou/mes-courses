# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe PathBarHelper do
  include PathBarHelper

  it "should build path elements with no link" do
    path_bar_element_with_no_link("Going nowhere").should == "Going nowhere"
  end

  it "matches elements with no link" do
    path_bar_element_with_no_link?(path_bar_element_with_no_link("anything")).should == true
    path_bar_element_with_no_link?(path_bar_element_for_current_resource("anything")).should == false
  end

  it "should build path elements for current resource" do
    path_bar_element_for_current_resource("You are here").should == ["You are here"]
  end

  it "should build path elements with explicit links" do
    path_bar_element("Somewhere", :controller => "dispatcher").should == ["Somewhere", {:controller => "dispatcher"}]
  end

end
