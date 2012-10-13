require 'spec_helper'

describe CguController do

  ignore_user_authentication

  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns an app_part" do
      get 'index'
      assigns(:app_part).should == ApplicationController::BLOG_APP_PART
    end
  end
end
