# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "/sessions/new.html.erb" do

  it "should display :password in french" do
    template.stub(:resource_name).and_return(:user)
    template.stub(:resource).and_return(stub_model(User))
    template.stub(:devise_mapping).and_return(stub("devise mapping", :rememberable? => false, :registerable? => false, :recoverable? => false, :confirmable? => false, :lockable? => false))

    render

    response.should contain("Mot de passe")
    response.should_not contain("Password")
  end

end
