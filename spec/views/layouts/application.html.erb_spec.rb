# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe "layouts/application.html.erb" do

  it "should render flash[:notice] to the user" do
    NOTICE = "Something went bad ..."
    flash[:notice] = NOTICE
    render
    response.should contain NOTICE
  end

end

