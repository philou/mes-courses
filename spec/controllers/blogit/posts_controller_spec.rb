# Copyright (C) 2012 by Philippe Bourgau

require 'spec_helper'

module Blogit
  describe PostsController do

    ignore_user_authentication

    before :each do
      # to avoid : ActionController::RoutingError: No route matches {:controller=>"blogit/posts"}
      @routes = Blogit::Engine.routes
    end

    it "should assign a body id" do
      get :index

      assigns[:body_id].should == ApplicationController::BLOG_BODY_ID
    end

    it "should assign a app part" do
      get :index

      assigns[:app_part].should == ApplicationController::BLOG_APP_PART
    end

    it "should use a custom blog layout" do
      get :index

      response.should render_template("layouts/blog")
    end

    it "computes tag frequencies" do
      Post.stub(:tag_counts).and_return(tags = stub("Tags"))

      get :index

      assigns[:tags].should == tags
    end

  end
end
