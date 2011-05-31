# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "/dish/new.html.erb" do

  it "should display a default name for the new dish" do
    render
    response.should contain("Nouvelle recette")
  end

end
