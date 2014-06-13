# Copyright (C) 2014 by Philippe Bourgau


require 'spec_helper'

describe CguController do

  ignore_user_authentication

  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it "assigns an app_part" do
      get 'index'
      expect(assigns(:app_part)).to eq ApplicationController::BLOG_APP_PART
    end
  end
end
