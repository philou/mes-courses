# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

# NB : I did not manage to create a spec macro because I did not manage to extend
# Rails.application.routes.url_helpers
# there must be a better way
module DummyController
  include PathBarHelper

  def dummy_path_bar_element
    path_bar_element_with_no_link("path bar element")
  end

  def index
    self.path_bar = new_path_bar
    redirect_to '/'
  end
end

describe ApplicationController do

  ignore_user_authentication

  context "body_id and app_part from path_bar" do

    context "starting with no link" do
      controller do
        include DummyController

        def new_path_bar
          [path_bar_element_with_no_link("on my own")]
        end
      end


      it "should be ''" do
        get :index

        assigns[:body_id].should == ApplicationController::NO_BODY_ID
        assigns[:app_part].should == ApplicationController::MAIN_APP_PART
      end
    end

    context "starting with cart lines" do
      controller do
        include DummyController

        def new_path_bar
          [path_bar_cart_lines_root, dummy_path_bar_element]
        end
      end

      it "should be cart" do
        get :index

        assigns(:body_id).should == ApplicationController::CART_BODY_ID
        assigns[:app_part].should == ApplicationController::MAIN_APP_PART
      end
    end

    context "starting with dishes" do
      controller do
        include DummyController

        def new_path_bar
          [path_bar_dishes_root, dummy_path_bar_element]
        end
      end

      it "should be dish" do
        get :index

        assigns(:body_id).should == ApplicationController::DISHES_BODY_ID
        assigns[:app_part].should == ApplicationController::MAIN_APP_PART
      end
    end

    context "starting with items" do
      controller do
        include DummyController

        def new_path_bar
          [path_bar_items_root, dummy_path_bar_element]
        end
      end

      it "should be item" do
        get :index

        assigns(:body_id).should == ApplicationController::ITEMS_BODY_ID
        assigns[:app_part].should == ApplicationController::MAIN_APP_PART
      end
    end

    context "starting with session" do
      controller do
        include DummyController

        def new_path_bar
          [path_bar_session_root, dummy_path_bar_element]
        end
      end

      it "should be session" do
        get :index

        assigns(:body_id).should == ApplicationController::SESSION_BODY_ID
        assigns[:app_part].should == ApplicationController::MAIN_APP_PART
      end
    end

    context "starting with something else" do
      controller do
        include DummyController

        def new_path_bar
          [:unhandled_path_bar_element]
        end
      end

      it "should throw" do
        lambda { get :index }.should raise_error
      end
    end

    context "with no path bar" do
      controller do
        include DummyController

        def index
          redirect_to '/'
        end
      end

      it "should not be assigned" do
        get :index

        assigns(:body_id).should be_nil
        assigns(:app_part).should be_nil
      end
    end
  end

  context "without a path_bar" do
    context "with presentation body id" do
      controller do
        def index
          self.body_id = ApplicationController::PRESENTATION_BODY_ID
          redirect_to '/'
        end
      end
      it "assigns body id and app part" do
        get :index

        assigns(:body_id).should == ApplicationController::PRESENTATION_BODY_ID
        assigns(:app_part).should == ApplicationController::BLOG_APP_PART
      end
    end
  end

  context "session place" do

    controller do
      include DummyController

      def new_path_bar
        [path_bar_dishes_root, dummy_path_bar_element]
      end

    end

    it "is signin before authentication" do
      get :index

      assigns(:session_place_text).should == "Connection"
      assigns(:session_place_url).should == new_user_session_path
    end

    it "is signout after authentication" do
      email = "gyzmo@mail.com"
      stub_signed_in_user(:email => email)

      get :index

      assigns(:session_place_text).should == "Deconnection (#{email})"
      assigns(:session_place_url).should == destroy_user_session_path
    end
  end
end
