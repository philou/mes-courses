# Copyright (C) 2012 by Philippe Bourgau

require 'spec_helper'

describe FeaturesController do

  ignore_user_authentication

  it "should assign a path_bar with index" do
    get :index

    expect(assigns[:path_bar]).not_to be_nil
  end

end
