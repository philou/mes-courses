# Copyright (C) 2012 by Philippe Bourgau

require 'spec_helper'

describe FeaturesController do

  ignore_user_authentication

  it "should assign a path_bar with index" do
    get :index

    assigns[:path_bar].should_not be_nil
  end

end
