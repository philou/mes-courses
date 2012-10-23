# Copyright (C) 2012 by Philippe Bourgau

require 'spec_helper'

module Blogit
  describe PostsController do

    ignore_user_authentication

    before :each do
      # to avoid : ActionController::RoutingError: No route matches {:controller=>"blogit/posts"}
      @routes = Blogit::Engine.routes
      get :index
    end

    it "should assign a body id" do
      assigns[:body_id].should == ApplicationController::BLOG_BODY_ID
    end

    it "should assign a app part" do
      assigns[:app_part].should == ApplicationController::BLOG_APP_PART
    end

  end
end
