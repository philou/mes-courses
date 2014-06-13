# -*- encoding: utf-8 -*-
# Copyright (C) 2014 by Philippe Bourgau

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
      expect(response).to be_success
      expect(response).to render_template('new')
    end

    it "assigns a 'Connection' path bar" do
      expect(assigns(:path_bar)).to eq [path_bar_session_root]
    end

  end

end
