require 'spec_helper'
require 'models/store_spec_helper'

describe Store do

  before(:each) do
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
    
    before(:each) do
      @store = Store.create(@valid_attributes)

      when_importing_from(@store, :skip_links_like => /^http:\/\//, :squeeze_loops_to => 3)

      @store.import
    end

    it "should create many items" do
      Item.should have_at_least(10).records
    end

    it "should create different items" do
      items = Item.find(:all)
      names = Set.new(items.map {|item| item.name})
      names.should have_at_least(items.length * 0.7).unique_values
    end

    it "should create full named items" do
      items = Item.find(:all).find_all {|item| 20 <= item.name.length }
      items.should have_at_least(1).item
    end

  end

end
