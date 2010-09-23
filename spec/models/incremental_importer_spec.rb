# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe IncrementalImporter do

  before(:each) do
    @store = stub_model(Store)
    @store.stub(:knows_item).and_return(false)
    @importer = IncrementalImporter.new(@store)
  end

  it "should forward found item types to its store" do
    should_delegate_to_store(:found_item_type, {})
  end
  it "should forward found item sub types to its store" do
    should_delegate_to_store(:found_item_sub_type, {})
  end
  it "should forward found items to its store" do
    should_delegate_to_store(:found_item, {})
  end

  it "should not forward found items to its store if it knows them already" do
    item = {}
    @store.stub(:knows_item).with(item).and_return(true)
    @store.should_not_receive(:found_item)
    @importer.found_item(item)
  end

  private

  def should_delegate_to_store(message, argument)
    @store.should_receive(message).with(argument)
    @importer.send(message, argument)
  end

end
