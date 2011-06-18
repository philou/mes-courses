# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'lib/array_extras'

describe ItemCategoryController do
  include ApplicationHelper

  before :each do
    @nesting = ItemCategoryControllerStandaloneNesting.new
    ItemCategoryControllerStandaloneNesting.stub(:new).and_return(@nesting)
  end

  def it_should_have_assigned_add_to_cart_attributes
    assigns[:add_item_label].should == @nesting.add_item_label
    assigns[:add_item_url_options].should == @nesting.add_item_url_options
    assigns[:add_item_html_options].should == @nesting.add_item_html_options
  end
  def it_should_have_assigned_show_sub_category_link_params
    assigns[:show_sub_category_url_options].should == @nesting.show_sub_category_url_options
  end

  describe "GET 'index'" do

    before :each do
      @item_categories = ["Marché","Poissonerie","Boucherie"].map do |name|
        stub_model(ItemCategory, :name => name)
      end
      ItemCategory.stub(:find).and_return(@item_categories)

      @nesting = ItemCategoryControllerStandaloneNesting.new
      ItemCategoryControllerStandaloneNesting.stub(:new).and_return(@nesting)
    end

    it "should render 'show'" do
      get 'index'

      response.should be_success
      response.should render_template("show")
    end

    it "should assign the root categories" do
      get 'index'

      assigns[:categories].should == @item_categories
    end

    it "should assign an empty array of items" do
      get 'index'

      assigns[:items].should == []
    end

    it "should use a standalone nesting" do
      ItemCategoryControllerStandaloneNesting.should_receive(:new)

      get 'index'
    end

    it "should assign the item search url of its nesting" do
      @nesting.stub(:item_category_index_path).and_return("all_categories_start_here")

      get 'index'

      assigns[:search_url].should == @nesting.item_category_index_path
    end

    it "should assign a path_bar starting with the path bar of its nesting" do
      @nesting.stub(:root_path_bar).and_return([:nesting_path_bar_item_1, :nesting_path_bar_item_2])
      get 'index'

      assigns[:path_bar].should be_starting_with(@nesting.root_path_bar)
    end
    it "should assign a path_bar ending with a link to all ingredients" do
      get 'index'

      assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_category_index_path)])
    end

    it "should assign the html body id of its nesting" do
      body_id = "the_body_inside_me"
      @nesting.stub(:html_body_id).and_return(body_id)

      get 'index'

      assigns[:body_id].should == body_id
    end

    it "should assign an add item to cart link attributes" do
      @nesting.stub(:add_item_label).and_return("Ajouter cela ici !")
      @nesting.stub(:add_item_url_options).and_return({ :option => "trés trés importante" })
      @nesting.stub(:add_item_html_options).and_return({ :le_html => "c'est trés important" })

      get 'index'

      it_should_have_assigned_add_to_cart_attributes
    end

    it "should assign show sub category link params" do
      @nesting.stub(:show_sub_category_url_options).and_return({ :url => "http://quelque.part.com"})

      get 'index'

      it_should_have_assigned_show_sub_category_link_params
    end

    describe "with dish id" do
      before :each do
        @dish = stub_model(Dish, :name => "Hamburger maison")
        Dish.stub!(:find_by_id).and_return(@dish)
      end

      it "should use a dish nesting and instead of a standalone nesting" do
        nesting = ItemCategoryControllerDishNesting.new(@dish.id.to_s)
        ItemCategoryControllerDishNesting.should_receive(:new).with(@dish.id.to_s).and_return(nesting)
        ItemCategoryControllerStandaloneNesting.should_not_receive(:new)

        get 'index', :dish_id => @dish.id
      end
    end

    describe "searching" do

      before :each do
        @keyword = "tomates"
        Item.stub(:search_by_keyword_and_category).and_return([])
      end

      def get_index_search
        get 'index', :search => { :keyword => @keyword }
      end

      it "should assign a path_bar matching the search" do
        get_index_search

        assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_category_index_path),
                                                  PathBar.element_with_no_link(@keyword)])
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
      @item_category = stub_model(ItemCategory, :id => 123, :name => "Légumes")
      ItemCategory.stub(:find_by_id).and_return(@item_category)
    end

    def get_show(params = {})
      get 'show', params.merge(:id => @item_category.id)
    end

    it "should be successful" do
      get_show

      response.should be_success
      response.should render_template("show")
    end

    it "should assign a search url given by its nesting for the current category" do
      @nesting.stub(:item_category_path).and_return("/item_category/id=special")

      get_show

      assigns[:search_url].should == @nesting.item_category_path
    end

    it "should assign item_category attributes" do
      get_show

      assigns[:categories].should == @item_category.children
      assigns[:items].should == @item_category.items
    end

    it "should assign a path bar starting with its nesting root path bar" do
      @nesting.stub(:root_path_bar).and_return([:path_bar_1, :path_bar_2])

      get_show

      assigns[:path_bar].should be_starting_with(@nesting.root_path_bar)
    end

    it "should assign a path bar with root category" do
      get_show

      assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_category_index_path),
                                                PathBar.element(@item_category.name, item_category_path(@item_category))])
    end

    it "should assign a full path bar with all parents" do
      parent_category = stub_model(ItemCategory, :id => 456, :name => "Marché")
      @item_category.parent = parent_category

      get_show

      assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_category_index_path),
                                                PathBar.element(parent_category.name, item_category_path(parent_category)),
                                                PathBar.element(@item_category.name, item_category_path(@item_category))])
    end


    it "should assign an add item to cart link attributes" do
      get_show

      it_should_have_assigned_add_to_cart_attributes
    end

    it "should assign show sub category link params" do
      get_show

      it_should_have_assigned_show_sub_category_link_params
    end

    describe "with dish id" do
      before :each do
        @dish = stub_model(Dish, :name => "Hamburger maison")
        Dish.stub!(:find_by_id).and_return(@dish)
      end

      it "should use a dish nesting and instead of a standalone nesting" do
        nesting = ItemCategoryControllerDishNesting.new(@dish.id.to_s)
        ItemCategoryControllerDishNesting.should_receive(:new).with(@dish.id.to_s).and_return(nesting)
        ItemCategoryControllerStandaloneNesting.should_not_receive(:new)

        get_show :dish_id => @dish.id
      end
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

      it "should assign a path_bar matching the search" do
        get_show_search

        assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_category_index_path),
                                                  PathBar.element(@item_category.name, item_category_path(@item_category)),
                                                  PathBar.element_with_no_link(@keyword)])
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
