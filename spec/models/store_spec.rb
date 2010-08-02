require 'spec_helper'
require 'models/store_spec_helper'

describe Store do

  before(:each) do
    @valid_attributes = {
      :url => "file://"+File.join(File.dirname(__FILE__),'offline_sites','www.auchandirect.fr', 'frontoffice', 'index.html')
    }
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  context "After import" do
    include StoreSpecHelper
    
    before(:each) do
      @store = Store.create(@valid_attributes)

      do_not_follow_online_links_when_importing_from(@store)
      do_not_follow_more_than_3_similar_links_when_importing_from(@store)
      
      @store.import
    end

    it "should import many items" do
      Item.should have_at_least(10).records
    end

#    it "should import item XXX"

  end

end
