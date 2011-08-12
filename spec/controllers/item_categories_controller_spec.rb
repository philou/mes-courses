# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'lib/array_extras'

describe ItemCategoriesController do
  include ApplicationHelper

  before :each do
    ItemCategory.stub(:root).and_return(stub_model(ItemCategory, :name => ItemCategory::ROOT_NAME, :items => []))

    @nesting = ItemCategoriesControllerStandaloneNesting.new
    ItemCategoriesControllerStandaloneNesting.stub(:new).and_return(@nesting)

    @dish = stub_model(Dish, :name => "Hamburger maison")
    Dish.stub!(:find_by_id).and_return(@dish)
  end

  def expect_use_of_dish_nesting
    nesting = ItemCategoriesControllerDishNesting.new(@dish.id.to_s)
    ItemCategoriesControllerDishNesting.should_receive(:new).with(@dish.id.to_s).and_return(nesting)
    ItemCategoriesControllerStandaloneNesting.should_not_receive(:new)
  end

  describe "GET 'index'" do

    it "should redirect to 'show' root item category" do
      get 'index'

      response.should redirect_to(item_category_path(ItemCategory.root))
    end

    it "should use a standalone nesting" do
      ItemCategoriesControllerStandaloneNesting.should_receive(:new)

      get 'index'
    end

    describe "with a dish" do
      it "should use a dish nesting instead of a standalone nesting" do
        expect_use_of_dish_nesting

        get 'index', :dish_id => @dish.id
      end

      it "should redirect to 'show' root item category" do
        get 'index', :dish_id => @dish.id

        response.should redirect_to(dish_item_category_path(@dish, ItemCategory.root))
      end

    end
  end

  describe "GET 'show'" do
    before :each do
      @item_category = stub_model(ItemCategory, :id => 123, :name => "Légumes", :parent => ItemCategory.root)
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

    it "should use a standalone nesting" do
      ItemCategoriesControllerStandaloneNesting.should_receive(:new)

      get_show
    end

    it "should assign a search url given by its nesting for the current category" do
      @nesting.stub(:item_category_path).and_return("/item_category/id=special")

      get_show

      assigns[:search_url].should == @nesting.item_category_path
    end

    it "should assign sub categories attributes" do
      get_show

      assigns[:categories].should == @item_category.children
    end

    it "should assign items attributes" do
      get_show

      assigns[:items].should == @item_category.items
    end

    it "should assign a path bar starting with its nesting root path bar" do
      @nesting.stub(:root_path_bar).and_return([:path_bar_1, :path_bar_2])

      get_show

      assigns[:path_bar].should be_starting_with(@nesting.root_path_bar)
    end

    it "should assign a path bar with current category" do
      get_show

      assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_categories_path),
                                                PathBar.element(@item_category.name, item_category_path(@item_category))])
    end

    it "should assign a full path bar with all parents" do
      parent_category = stub_model(ItemCategory, :id => 456, :name => "Marché", :parent => ItemCategory.root)
      @item_category.stub(:parent).and_return(parent_category)

      get_show

      assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_categories_path),
                                                PathBar.element(parent_category.name, item_category_path(parent_category)),
                                                PathBar.element(@item_category.name, item_category_path(@item_category))])
    end

    it "should assign the html body id of its nesting" do
      body_id = "the_body_inside_me"
      @nesting.stub(:html_body_id).and_return(body_id)

      get_show

      assigns[:body_id].should == body_id
    end

    it "should assign an add item to cart link attributes" do
      @nesting.stub(:add_item_label).and_return("Ajouter cela ici !")
      @nesting.stub(:add_item_url_options).and_return({ :option => "trés trés importante" })
      @nesting.stub(:add_item_html_options).and_return({ :le_html => "c'est trés important" })

      get_show

      assigns[:add_item_label].should == @nesting.add_item_label
      assigns[:add_item_url_options].should == @nesting.add_item_url_options
      assigns[:add_item_html_options].should == @nesting.add_item_html_options
    end

    it "should assign show sub category link params" do
      @nesting.stub(:show_sub_category_url_options).and_return({ :url => "http://quelque.part.com"})

      get_show

      assigns[:show_sub_category_url_options].should == @nesting.show_sub_category_url_options
    end

    describe "when showing ItemCategory root" do

      it "should assign a path_bar ending with a link to all ingredients" do
        ItemCategory.stub(:find_by_id).and_return(ItemCategory.root)

        get 'show', :id => ItemCategory.root.id

        assigns[:path_bar].should be_ending_with([PathBar.element("Ingrédients", item_categories_path)])
      end

    end

    describe "with dish id" do
      it "should use a dish nesting instead of a standalone nesting" do
        expect_use_of_dish_nesting

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

      it "should assign a path_bar containing the searched category" do
        get_show_search

        assigns[:path_bar].should be_containing([PathBar.element("Ingrédients", item_categories_path),
                                                 PathBar.element(@item_category.name, item_category_path(@item_category))])
      end

      it "should assign a path_bar ending with the search" do
        get_show_search

        assigns[:path_bar].should be_ending_with([PathBar.element_with_no_link(@keyword)])
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