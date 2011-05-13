# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe PathBar do

  it "should build path elements with no link" do
    PathBar.element_with_no_link("Going nowhere").should == "Going nowhere"
  end

  it "should build path elements for current resource" do
    PathBar.element_for_current_resource("You are here").should == ["You are here"]
  end

  it "should build path elements with explicit links" do
    PathBar.element("Somewhere", :controller => "dispatcher").should == ["Somewhere", {:controller => "dispatcher"}]
  end

end
