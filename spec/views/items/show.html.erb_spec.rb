
require 'spec_helper'

describe "items/show.html.erb" do

  before(:each) do
    assigns[:items] = ["Tomatoes", "Potatoes"].map {|name| stub("Item", :name => name) }
  end

  it "displays the name of the first item" do
    render
    response.should contain("Tomatoes")
  end

  it "displays the name of the second item" do
    render
    response.should contain("Potatoes")
  end

end

