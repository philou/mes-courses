require 'spec_helper'

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
    
    def do_not_follow_online_links
      def @store.skip_link?(uri)
        uri =~ /^http:\/\//
      end
    end
    def do_not_follow_more_than_3_similar_links
      def @store.each_node(collection)
        i = 0
        collection.each do |item|
          if 3 <= i
            return
          else
            yield item
          end
          i = i+1
        end
      end
    end

    before(:each) do
      @store = Store.create(@valid_attributes)

      do_not_follow_online_links
      do_not_follow_more_than_3_similar_links
      
      @store.import
    end

    it "should import many items" do
      Item.should have_at_least(10).records
    end

#    it "should import item XXX"

  end

end
