# -*- encoding: utf-8 -*-
require 'spec_helper'

describe SessionsController do
  include PathBarHelper
  include Devise::TestHelpers

  context "when get 'new'" do

    before :each do
      get 'new'
    end

    it "renders 'new' template" do
      response.should be_success
      response.should render_template('new')
    end

    it "assigns a 'Connection' path bar" do
      assigns[:path_bar].should == [path_bar_session_root]
    end

  end

end
