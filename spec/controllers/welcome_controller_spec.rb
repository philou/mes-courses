# Copyright (C) 2012 by Philippe Bourgau

require 'spec_helper'

describe WelcomeController do

  ignore_user_authentication

  before :each do
    get :index
  end

  it "should assign a body id" do
    expect(assigns[:body_id]).to eq ApplicationController::PRESENTATION_BODY_ID
  end

  it "should assign a app part" do
    expect(assigns[:app_part]).to eq ApplicationController::BLOG_APP_PART
  end

end
