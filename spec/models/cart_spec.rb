require 'spec_helper'
require 'models/store_spec_helper'

describe Cart do

  before(:each) do
    @cart = Cart.new
  end

  it "should have no items when created" do
    @cart.items.should be_empty
  end

  it "should contain added items" do
    items = Array.new(5) {|i| stub(Item, :name => "item_#{i}") }
    items.each {|item| @cart.add_item(item) }

    items.each {|item| @cart.items.should include(item) }
  end

end
