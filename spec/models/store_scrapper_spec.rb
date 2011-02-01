# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/store_scrapping_test_strategy'
require 'mostly_matcher'
require 'all_matcher'
require 'have_unique_matcher'

describe StoreScrapper do

  def initialize_scrapper(tweaks = {})
    @strategy = StoreScrappingTestStrategy.new(tweaks)
    @scrapper = StoreScrapper.new(:scrapping_strategy => @strategy)
    @store = stub("Store").as_null_object
    @store.stub(:already_visited_url?).and_return(false)
  end

  def scrap
    @scrapper.import(AUCHAN_DIRECT_OFFLINE, @store)
  end

  context "when starting from scratch" do

    # we are importing only once because it takes a lot of time. All the tests should be side effect free.
    before(:all) do
      initialize_scrapper(:max_loop_nodes => 2)
      record_calls(@store, :starting_import, :finishing_import, :register_item_category, :register_item, :register_visited_url)

      scrap
    end

    def record_calls(stub_object, *selectors)
      @recorded_calls = []
      selectors.each do |selector|
        record_calls_to(stub_object, selector)
      end
    end
    def record_calls_to(stub_object, selector)
      collector = []
      self.instance_variable_set("@#{selector.to_s.pluralize}".intern, collector)

      # warning because start_import and stop_import does not have any arguments ...
      stub_object.stub(selector) do |*args|
        recorded_args = arguments(args)

        @recorded_calls.push({:selector => selector, :arguments => recorded_args})
        collector.push(recorded_args)
        recorded_args
      end
    end
    def arguments(args)
      if (args.count == 1)
        args.first
      else
        args
      end
    end
    def calls_with_selector(selector)
      @recorded_calls.find_all do |call|
        call[:selector] == selector
      end
    end

    def first_index_where(array)
      array.each_with_index do |item, i|
        if yield item
          return i
        end
      end
      return -1
    end

    it "should call start_import before registering items" do
      @recorded_calls.first[:selector].should == :starting_import
      calls_with_selector(:starting_import).should have(1).entry
    end
    it "should call stop_import before registering items" do
      @recorded_calls.last[:selector].should == :finishing_import
      calls_with_selector(:finishing_import).should have(1).entry
    end

    it "should create many items" do
      @register_items.should have_at_least(3).records
    end

    it "should create item categories" do
      @register_item_categories.should_not be_empty
    end

    it "should create different items categories" do
      @register_item_categories.should mostly have_unique(:name)
    end

    it "should organize items with a category hierarchy" do
      @register_items.each do |item|
        item[:item_category].should_not be_nil
        item[:item_category][:parent].should_not be_nil
      end
    end

    it "should create different items" do
      @register_items.should mostly have_unique(:name)
    end

    it "should create full named items" do
      @register_items.find_all {|item| 20 <= item[:name].length }.should_not be_empty
    end

    it "should create items with a price" do
      @register_items.should all have_key(:price)
    end

    it "should create most items with an image" do
      @register_items.should mostly have_key(:image)
    end

    it "should create most items with a summary" do
      @register_items.should mostly have_key(:summary)
    end

    it "should register a visited url for every registered thing" do
      @register_visited_urls.count.should == (@register_item_categories.count + @register_items.count + 1)
      # +1 for the whole site ... if this breaks too often, use an inequality
    end
    it "should register visited urls as instances of uri" do
      @register_visited_urls.should all be_instance_of(String)
    end
    it "should register visited url AFTER the item was registered" do
      item_save_call = first_index_where(@recorded_calls) { |item| item[:selector] == :register_item }
      # If this breaks too often, search the next item save, and verify there is a register_url between them
      @recorded_calls[item_save_call+1][:selector].should == :register_visited_url
    end
  end

  context "when starting after a previous one" do

    # A fresh but tiny scrapping for each test
    before(:each) do
      initialize_scrapper(:max_loop_nodes => 1)
    end

    it "should start a new import if the last one finished" do
      @store.should_receive(:last_import_finished?).and_return(true)
      @store.should_receive(:starting_import)

      scrap
    end

    it "should not start a new import if the last one did not finish" do
      @store.should_receive(:last_import_finished?).and_return(false)
      @store.should_not_receive(:starting_import)

      scrap
    end

    it "should not register item categories if urls were visited" do
      @store.should_receive(:already_visited_url?).with(instance_of(String)).and_return(true)
      @store.should_not_receive(:register_item_category)

      scrap
    end

    it "should register items if urls were not visited" do
      @store.should_receive(:already_visited_url?).with(instance_of(String)).and_return(false)
      @store.should_receive(:register_item)

      scrap
    end

  end

  it "should let interrupts and other fatal exception climb up the stack" do
    exception_should_climb_up_the_stack(Interrupt)
  end

  it "should let standard errors climb up the stack" do
    exception_should_climb_up_the_stack(SocketError)
  end

  def exception_should_climb_up_the_stack(exception_class)
    initialize_scrapper(:max_loop_nodes => 1, :simulate_error_at_node => 0, :simulated_error => exception_class)
    lambda { scrap }.should raise_error(exception_class)
  end

  it "should continue on unscrappable store pages" do
    new_page = Mechanize::Page.method(:new)
    Mechanize::Page.stub!(:new).and_return do |*args|
      result = new_page.call(*args)
      result.stub!(:search).and_return([])
      result
    end

    initialize_scrapper(:max_loop_nodes => 3)
    lambda { scrap }.should_not raise_error
  end

  it "should continue badly formed store items" do
    initialize_scrapper(:max_loop_nodes => 3)
    @store.stub!(:register_item).and_raise(ActiveRecord::RecordInvalid.new(Item.new))
    lambda { scrap }.should_not raise_error
  end

end
