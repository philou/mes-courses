# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "sessions/new" do

  it "should display :password in french" do
    view.stub(:resource_name).and_return(:user)
    view.stub(:resource).and_return(stub_model(User))
    view.stub(:devise_mapping).and_return(double("devise mapping", :rememberable? => false, :registerable? => false, :recoverable? => false, :confirmable? => false, :lockable? => false, :omniauthable? => false))

    render

    expect(rendered).to contain("Mot de passe")
    expect(rendered).not_to contain("Password")
  end

end
