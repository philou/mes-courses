# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

class TestController < ApplicationController
  include PathBarHelper

  def an_action_with_cart_path_bar
    self.path_bar = [path_bar_cart_lines_root, path_bar_element_with_no_link("path bar element")]
  end
  def an_action_with_dish_path_bar
    self.path_bar = [path_bar_dishes_root, path_bar_element_with_no_link("path bar element")]
  end
  def an_action_with_item_path_bar
    self.path_bar = [path_bar_items_root, path_bar_element_with_no_link("path bar element")]
  end
  def an_action_with_unhandled_path_bar
    self.path_bar = [:unhandled_path_bar_element]
  end
  def an_action_with_redirection
    redirect_to :action => "nowhere"
  end

end

describe ApplicationController do
  controller_name :test

  context "assigning @body_id" do

    it "should be cart for a @path_bar starting with cart lines" do
      get 'an_action_with_cart_path_bar'

      assigns[:body_id].should == 'cart'
    end

    it "should be dish for a @path_bar starting with dishes" do
      get 'an_action_with_dish_path_bar'

      assigns[:body_id].should == 'dish'
    end

    it "should be item for a @path_bar starting with items" do
      get 'an_action_with_item_path_bar'

      assigns[:body_id].should == 'items'
    end

    it "should throw for a @path_bar starting with something else" do
      lambda { get 'an_action_with_unhandled_path_bar' }.should raise_error
    end

    it "should not assign any body_id when there is a redirection" do
      get 'an_action_with_redirection'

      assigns[:body_id].should be_nil
    end

  end

end
