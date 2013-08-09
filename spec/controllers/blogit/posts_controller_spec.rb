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

      expect(assigns[:body_id]).to eq ApplicationController::BLOG_BODY_ID
    end

    it "should assign a app part" do
      get :index

      expect(assigns[:app_part]).to eq ApplicationController::BLOG_APP_PART
    end

    it "should use a custom blog layout" do
      get :index

      expect(response).to render_template("layouts/blog")
    end

    it "computes tag frequencies" do
      Post.stub(:tag_counts).and_return(tags = double("Tags"))

      get :index

      expect(assigns[:tags]).to eq tags
    end

  end
end
