# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

shared_examples_for "Any StoreItemsAPI" do

  before :all do
    @range = 0..1
  end

  def collect_all(categories, message)
    categories.map { |cat| cat.send(message)[@range] }.flatten
  end

  def sample_categories
    @store.categories[@range]
  end
  def sample_sub_categories
    collect_all(sample_categories, :categories)
  end
  def sample_items
    collect_all(sample_sub_categories, :items)
  end
  def sample_items_attributes
    sample_items.map &:attributes
  end

  it "should have many item categories" do
    @store.categories.should have_at_least(3).items
  end

  it "should have many item sub categories" do
    sample_sub_categories.should have_at_least(3).items
  end

  it "should have many items" do
    sample_items.should have_at_least(3).items
  end

  it "should have item categories with different names" do
    categories_attributes = @store.categories.map { |cat| cat.attributes }
    categories_attributes.should mostly have_unique(:name)
  end

  it "should have items with different names" do
    sample_items_attributes.should mostly have_unique(:name)
  end

  it "should have valid item attributes" do
    lambda do

      sample_items do |item|
        Item.new(item.attributes)
      end

    end.should_not raise_error
  end

  it "should have full named items" do
    sample_items_attributes.find_all {|item| 20 <= item[:name].length }.should_not be_empty
  end

  it "should have items with a price" do
    sample_items_attributes.should all have_key(:price)
  end

  it "should mostly have items with an image" do
    sample_items_attributes.should mostly have_key(:image)
  end

  it "should mostly have items with a summary" do
    sample_items_attributes.should mostly have_key(:summary)
  end

  it "should have items with a remote id" do
    sample_items_attributes.should all have_key(:remote_id)
  end

end
