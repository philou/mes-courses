require 'spec_helper'

describe ItemCategoryController do
  include ApplicationHelper

  describe "GET 'index'" do
    before :each do
      @item_categories = ["Marché","Poissonerie","Boucherie"].map do |name|
        stub_model(ItemCategory, :name => name)
      end
      ItemCategory.stub(:find).and_return(@item_categories)
    end

    def get_index
      get 'index'
    end

    it "should render 'show'" do
      get_index

      response.should be_success
      response.should render_template("show")
    end

    it "should assign a global title" do
      get_index

      assigns[:title].should == "Ingrédients"
    end

    it "should assign the root categories" do
      get_index

      assigns[:categories].should == @item_categories
    end

    it "should assign an empty array of items" do
      get_index

      assigns[:items].should == []
    end

    it "should assign the global item search url" do
      get_index

      assigns[:search_url].should == any_item_category_path
    end

    describe "searching" do

      before :each do
        @keyword = "tomates"
        Item.stub(:search_by_keyword_and_category).and_return([])
      end

      def get_index_search
        get 'index', :search => { :keyword => @keyword }
      end

      it "should assign a title matching the search" do
        get_index_search

        assigns[:title].should == "Résultats de la recherche pour \"#{@keyword}\""
      end

      it "should assign the global item search url" do
        get_index_search

        assigns[:search_url].should == any_item_category_path
      end

      it "should assign no categories" do
        ItemCategory.stub(:find).and_return([Factory.create(:item)])

        get_index_search

        assigns[:categories].should == []
      end

      it "should assign searched items" do
        searched_items = [Factory.create(:item)]
        Item.should_receive(:search_by_keyword_and_category).with(@keyword).and_return(searched_items)

        get_index_search

        assigns[:items].should == searched_items
      end

    end
  end

  describe "GET 'show'" do
    before :each do
      @item_category = stub_model(ItemCategory, :id => 123)
      ItemCategory.stub(:find_by_id).and_return(@item_category)
      get 'show', :id => @item_category.id
    end

    it "should be successful" do
      response.should be_success
      response.should render_template("show")
    end

    it "should assign item_category attributes" do
      assigns[:title].should == @item_category.name
      assigns[:search_url].should == item_category_path(@item_category)
      assigns[:categories].should == @item_category.children
      assigns[:items].should == @item_category.items
    end

    describe "searching" do

      before :each do
        @keyword = "poulet"
        @item_category.name = "Marché"
        Item.stub(:search_by_keyword_and_category).and_return([])
      end

      def get_show_search
        get 'show', :id => @item_category.id, :search => { :keyword => @keyword }
      end

      it "should assign a title matching the search" do
        get_show_search

        assigns[:title].should == "Résultats de la recherche pour \"#{@keyword}\" dans \"#{@item_category.name}\""
      end

      it "should assign the global item search url" do
        get_show_search

        assigns[:search_url].should == any_item_category_path(@item_category)
      end

      it "should assign no categories" do
        @item_category.children = [Factory.create(:item_category)]

        get_show_search

        assigns[:categories].should == []
      end

      it "should assign searched items" do
        searched_items = [Factory.create(:item)]
        Item.should_receive(:search_by_keyword_and_category).with(@keyword, @item_category).and_return(searched_items)

        get_show_search

        assigns[:items].should == searched_items
      end

    end
  end

end
