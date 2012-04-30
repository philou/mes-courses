# -*- encoding: utf-8 -*-
require 'spec_helper'

describe SessionsController do
  include PathBarHelper
  include Devise::TestHelpers

  context "when get 'new'" do

    before :each do
      # NB see http://stackoverflow.com/questions/4291755/rspec-test-of-custom-devise-session-controller-fails-with-abstractcontrollerac for the following line :
      request.env['devise.mapping'] = Devise.mappings[:user]

      get 'new'
    end

    it "renders 'new' template" do
      response.should be_success
      response.should render_template('new')
    end

    it "assigns a 'Connection' path bar" do
      assigns(:path_bar).should == [path_bar_session_root]
    end

  end

end
