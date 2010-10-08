# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe IncrementalStore do

  before(:each) do
    @store = stub_model(Store)
    @store.stub(:known_item).and_return(nil)
    @i_store = IncrementalStore.new(@store)
  end

  it "should forward found item types to its store" do
    should_register_in_store(:register_item_type, {}, ItemType)
  end
  it "should forward found item sub types to its store" do
    should_register_in_store(:register_item_sub_type, {}, ItemSubType)
  end
  it "should forward found items to its store" do
    should_register_in_store(:register_item, {}, Item)
  end

  context "when importing known items" do
    before(:each) do
      @attributes = {:name => "Truite", :price => 2.4}
      @known_item = Item.new(@attributes)
      @store.stub(:known_item).with("Truite").and_return(@known_item)
    end

    it "should check if the item has changed" do
      @known_item.should_receive(:equal_to_attributes?).with(@attributes).and_return(false)
      @i_store.register_item(@attributes)
    end

    context "that did not change" do
      it "should not register any item" do
        @store.should_not_receive(:register_item)
        @i_store.register_item(@attributes)
      end

      it "should return the known item" do
        known_item = @i_store.register_item(@attributes)
        known_item.should be_an(Item)
        known_item.name.should == @attributes[:name]
      end
    end
    context "that have changed" do
      before(:each) do
        @attributes[:price] = 2.1
      end

      it "should update the item" do
        @known_item.should_receive(:attributes=).with(@attributes)
        @i_store.register_item(@attributes)
      end

      it "should register the modified item" do
        @store.should_receive(:register_item).with(@known_item)
        @i_store.register_item(@attributes)
      end

      it "should return the updated item" do
        @i_store.register_item(@attributes).should == @known_item
      end
    end
  end

  private
  def should_register_in_store(message, argument, recordType)
    @store.should_receive(message).with(instance_of(recordType))
    result = @i_store.send(message, argument)
    result.should be_an(recordType)
  end

end
