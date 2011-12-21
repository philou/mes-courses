# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

class TestController < ApplicationController
  include PathBarHelper

  def an_action_with_cart_path_bar
    self.path_bar = [path_bar_cart_lines_root, dummy_path_bar_element]
  end
  def an_action_with_dish_path_bar
    self.path_bar = [path_bar_dishes_root, dummy_path_bar_element]
  end
  def an_action_with_item_path_bar
    self.path_bar = [path_bar_items_root, dummy_path_bar_element]
  end
  def an_action_with_session_path_bar
    self.path_bar = [path_bar_session_root, dummy_path_bar_element]
  end
  def an_action_with_unhandled_path_bar
    self.path_bar = [:unhandled_path_bar_element]
  end
  def an_action_with_redirection
    redirect_to :action => "nowhere"
  end

  private

  def dummy_path_bar_element
    path_bar_element_with_no_link("path bar element")
  end

end

describe ApplicationController do

  controller_name :test

  ignore_user_authentication

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

    it "should be session for a @path_bar starting with session" do
      get 'an_action_with_session_path_bar'

      assigns[:body_id].should == 'session'
    end

    it "should throw for a @path_bar starting with something else" do
      lambda { get 'an_action_with_unhandled_path_bar' }.should raise_error
    end

    it "should not assign any body_id when there is a redirection" do
      get 'an_action_with_redirection'

      assigns[:body_id].should be_nil
    end

  end

  context "user authentication" do

    ["an_action_with_cart_path_bar", "an_action_with_dish_path_bar", "an_action_with_item_path_bar", "an_action_with_redirection"].each do |action|

      it "should authenticate user before #{action}" do
        controller.should_receive(:authenticate_user!)

        get action
      end
    end
  end

  it "assigns a signin session_place before authentification" do
    controller.stub(:user_signed_in?).and_return(false)

    get 'an_action_with_session_path_bar'

    assigns[:session_place_text].should == "Connection"
    assigns[:session_place_url].should == new_user_session_path
  end

  it "assigns a signout session_place after authentification" do
    email = "gyzmo@mail.com"
    controller.stub(:current_user).and_return(stub_model(User, :email => email))

    get 'an_action_with_cart_path_bar'

    assigns[:session_place_text].should == "Deconnection (#{email})"
    assigns[:session_place_url].should == destroy_user_session_path
  end

end
