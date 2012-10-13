# Copyright (C) 2012 by Philippe Bourgau

require 'spec_helper'

describe WelcomeController do

  ignore_user_authentication

  before :each do
    get :index
  end

  it "should assign a body id" do
    assigns[:body_id].should == ApplicationController::PRESENTATION_BODY_ID
  end

  it "should assign a app part" do
    assigns[:app_part].should == ApplicationController::BLOG_APP_PART
  end

end
