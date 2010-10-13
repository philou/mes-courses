# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe IncrementalStore do

  before(:each) do
    @store = stub_model(Store)
    @store.stub(:known).and_return(nil)
    [:mark_existing_items, :mark_not_sold_out, :delete_sold_out_items,
     :delete_empty_item_types, :delete_empty_item_sub_types].each do |message|
      @store.stub(message)
    end
    @i_store = IncrementalStore.new(@store)
  end

  it "should mark existing items from the store when starting import" do
    @store.should_receive(:mark_existing_items)
    @i_store.starting_import
  end
  context "when finishing import" do
    after(:each) do
      @i_store.finishing_import
    end

    it "should delete sold out items from the store" do
      @store.should_receive(:delete_sold_out_items)
    end
    it "should delete empty item sub types" do
      @store.should_receive(:delete_empty_item_sub_types)
    end
    it "should delete empty item types" do
      @store.should_receive(:delete_empty_item_types)
    end
  end

  it "should register found item types to its store" do
    should_register_in_store(:register_item_type, {}, ItemType)
  end
  it "should register found item sub types to its store" do
    should_register_in_store(:register_item_sub_type, {}, ItemSubType)
  end
  it "should register found items to its store" do
    should_register_in_store(:register_item, {}, Item)
  end

  it "should tell the store that new items are not sold out" do
    should_tell_the_store_that_item_is_not_sold_out({})
  end

  context "when importing known items" do
    before(:each) do
      @attributes = {:name => "Truite", :price => 2.4}
      @known_item = Item.new(@attributes)
      @store.stub(:known).with(Item,"Truite").and_return(@known_item)
    end

    it "should check if the item has changed" do
      @known_item.should_receive(:equal_to_attributes?).with(@attributes).and_return(false)
      @i_store.register_item(@attributes)
    end

    context "that did not change" do
      it "should not register any item" do
        @store.should_not_receive(:register!)
        @i_store.register_item(@attributes)
      end

      it "should return the known item" do
        known_item = @i_store.register_item(@attributes)
        known_item.should be_an(Item)
        known_item.name.should == @attributes[:name]
      end

      it "should tell the store that new items are not sold out" do
        should_tell_the_store_that_item_is_not_sold_out(@attributes)
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
        @store.should_receive(:register!).with(@known_item)
        @i_store.register_item(@attributes)
      end

      it "should return the updated item" do
        @i_store.register_item(@attributes).should == @known_item
      end

      it "should tell the store that new items are not sold out" do
        should_tell_the_store_that_item_is_not_sold_out(@attributes)
      end
    end
  end

  it "should not register known item types" do
    should_not_register_known_item_class(:register_item_type, ItemType, "Viandes")
  end
  it "should not register known item sub types" do
    should_not_register_known_item_class(:register_item_sub_type, ItemSubType, "Boeuf")
  end

  private
  def should_register_in_store(message, argument, recordType)
    @store.should_receive(:register!).with(instance_of(recordType))
    result = @i_store.send(message, argument)
    result.should be_an(recordType)
  end

  def should_tell_the_store_that_item_is_not_sold_out(item_hash)
    @store.should_receive(:mark_not_sold_out).with(instance_of(Item))
    @i_store.register_item(item_hash)
  end

  def should_not_register_known_item_class(selector, model, name)
    attributes = {:name => name}
    @store.should_receive(:known).with(model, name).and_return(model.new(attributes))
    @store.should_not_receive(:register!)
    @i_store.send(selector, attributes)
  end

end
