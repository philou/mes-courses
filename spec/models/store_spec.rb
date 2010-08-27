require 'spec_helper'
require 'models/store_spec_helper'

describe Store do

  # setting static constants up
  before(:all) do
    dirname = File.expand_path(File.dirname(__FILE__))
    @valid_attributes = {
      :url => "file://"+File.join(dirname,'offline_sites','www.auchandirect.fr', 'frontoffice', 'index.html')
    }
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  context "when importing" do
    include StoreSpecHelper
    
    # we are importing only once because it takes a lot of time. All the tests should be side effect free.
    before(:all) do
      @items = []
      @store = Store.new(@valid_attributes)
      when_importing_from(@store, :skip_links_like => /^http:\/\//, :squeeze_loops_to => 2, :do_not_save_but_collect_items_in => @items)
      @store.import
    end

    it "should create many items" do
      @items.should have_at_least(3).records
    end

    it "should create different items" do
      names = Set.new(@items.map {|item| item.name})
      names.should have_at_least(@items.length * 0.7).unique_values
    end

    it "should create full named items" do
      items = @items.find_all {|item| 20 <= item.name.length }
      items.should have_at_least(1).item
    end

  end

end
