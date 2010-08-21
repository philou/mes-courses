require 'spec_helper'
require 'models/store_spec_helper'

# Matcher to verify that many elements are present in a collection
Spec::Matchers.define :include_all do |required_items|
  match do |actual|
    include_all?(actual,required_items)
  end
  failure_message_for_should do |actual|
    "#{missing_items(actual,required_items)} are missing"
  end
  failure_message_for_should_not do |actual|
    "at least one element of #{required_items} should be absent"
  end
  description do
    "expected a collection containing all elements from #{required_items}"
  end

  def include_all?(collection,required_items)
    required_items.each do |item|
      if !collection.include?(item)
        return false
      end
    end
    true
  end

  def missing_items(collection, required_items)
    result = []
    required_items.each do |item|
      if !collection.include?(item)
        result.push(item)
      end
    end
    result
  end

end

describe Cart do

  before(:each) do
    @cart = Cart.new
    @items = Array.new(5) {|i| stub(Item, :name => "item_#{i.to_s}") }
  end

  it "should have no items when created" do
    @cart.items.should be_empty
  end

  it "should contain added items" do
    @items.each {|item| @cart.add_item(item) }
    @cart.items.should include_all(@items)
  end

  it "should contain items from added dishes" do
    @cart.add_dish(stub(Dish, :name => "Home made soup", :items => @items))
    @cart.items.should include_all(@items)
  end

end
