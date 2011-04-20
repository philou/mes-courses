require 'spec_helper'

describe ItemCategoryController do

  describe "GET 'index'" do
    before :each do
      @item_categories = ["Marché","Poissonerie","Boucherie"].map do |name|
        stub_model(ItemCategory, :name => name)
      end
      ItemCategory.stub(:find).and_return(@item_categories)
      get 'index'
    end

    it "should be successful" do
      response.should be_success
      response.should render_template("show")
    end

    it "should assign a dummy item_category instance variable" do
      item_category = assigns[:item_category]
      item_category.should be_an_instance_of(ItemCategory)
      item_category.id.should be_nil
    end

    it "should set a global title to the dummy item_category instance variable" do
      item_category = assigns[:item_category]
      item_category.name.should == "Ingrédients"
    end

    it "should set the root categories as children of the dummy item_category instance variable" do
      item_category = assigns[:item_category]

      @item_categories.each_with_index do |category, i|
        item_category.children[i].should be category
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

    it "should be successful" do
      assigns[:item_category].should be @item_category
    end
  end
end
