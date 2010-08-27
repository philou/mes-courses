require 'spec_helper'
require 'nulldb_rspec'

describe "cart/show.html.erb" do
  include NullDB::RSpec::NullifiedDatabase

  before(:each) do
    assigns[:cart] = stub(Cart, :items => ["Tomates", "Pommes de terre"].map {|name| stub(Item, :name => name) } )
  end

  it "displays the first item" do
    render
    response.should contain("Tomates")
  end

  it "displays the second item" do
    render
    response.should contain("Pommes de terre")
  end

end

