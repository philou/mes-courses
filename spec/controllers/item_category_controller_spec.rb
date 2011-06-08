# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

shared_examples_for "Any controller listing all item categories" do
  include ApplicationHelper

  before :each do
    @item_categories = ["Marché","Poissonerie","Boucherie"].map do |name|
      stub_model(ItemCategory, :name => name)
    end
    ItemCategory.stub(:find).and_return(@item_categories)
  end

  it "should render 'show'" do
    get 'index', @params

    response.should be_success
    response.should render_template("show")
  end

  it "should assign the root categories" do
    get 'index', @params

    assigns[:categories].should == @item_categories
  end

  it "should assign an empty array of items" do
    get 'index', @params

    assigns[:items].should == []
  end

  it "should assign the global item search url" do
    get 'index', @params

    assigns[:search_url].should == any_item_category_path
  end

end

describe ItemCategoryController do
  include ApplicationHelper

  def it_should_have_assigned_add_to_cart_attributes
    assigns[:add_item_label].should == "Ajouter au panier"
    assigns[:add_item_url_options].should == { :controller => 'cart', :action => 'add_item'}
    assigns[:add_item_html_options].should == { :method => :get }
  end
  def it_should_have_assigned_show_sub_category_link_params
    assigns[:show_sub_category_url_options].should == {:controller => 'item_category', :action => 'show'}
  end

  describe "GET 'index'" do

    before :each do
      @params = {}
    end

    it_should_behave_like "Any controller listing all item categories"

    it "should assign a global path_bar" do
      get 'index', @params

      assigns[:path_bar].should == [PathBar.element("Ingrédients", item_category_index_path)]
    end

    it "should assign 'items' to html body id" do
      get 'index', @params

      assigns[:body_id].should == 'items'
    end

    it "should assign an add item to cart link attributes" do
      get 'index', @params

      it_should_have_assigned_add_to_cart_attributes
    end

    it "should assign show sub category link params" do
      get 'index', @params

      it_should_have_assigned_show_sub_category_link_params
    end

    describe "with dish id" do
      before :each do
        @dish = stub_model(Dish, :name => "Hamburger maison")
        Dish.stub!(:find_by_id).and_return(@dish)

        @params = {:dish_id => @dish.id}
      end

      it_should_behave_like "Any controller listing all item categories"

      it "should assign a path bar with the dishes as root" do
        get 'index', @params

        assigns[:path_bar].should == [PathBar.element("Recettes", dish_index_path),
                                      PathBar.element(@dish.name, dish_path(@dish)),
                                      PathBar.element("Ingrédients", dish_item_category_index_path(@dish))]
      end

      it "should assign 'items' to html body id" do
        get 'index', @params

        assigns[:body_id].should == 'dish'
      end

      it "should assign an add item to dish link attributes" do
        get 'index', @params

        assigns[:add_item_label].should == "Ajouter à la recette"
        assigns[:add_item_url_options].should == { :controller => 'items', :action => 'create', :dish_id => @dish.id.to_s}
        assigns[:add_item_html_options].should == { :method => :post }
      end

      it "should assign show sub category link params with a dish id" do
        get 'index', @params

        assigns[:show_sub_category_url_options].should == {:controller => 'item_category', :action => 'show', :dish_id => @dish.id.to_s}
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

        assigns[:path_bar].should == [PathBar.element("Ingrédients", item_category_index_path),
                                      PathBar.element_with_no_link(@keyword)]
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

    it "should assign item_category attributes" do
      get_show

      assigns[:search_url].should == item_category_path(@item_category)
      assigns[:categories].should == @item_category.children
      assigns[:items].should == @item_category.items
    end

    it "should assign a path bar with root category" do
      get_show

      assigns[:path_bar].should == [PathBar.element("Ingrédients", item_category_index_path),
                                    PathBar.element(@item_category.name, item_category_path(@item_category))]
    end

    it "should assign a full path bar with all parents" do
      parent_category = stub_model(ItemCategory, :id => 456, :name => "Marché")
      @item_category.parent = parent_category

      get_show

      assigns[:path_bar].should == [PathBar.element("Ingrédients", item_category_index_path),
                                    PathBar.element(parent_category.name, item_category_path(parent_category)),
                                    PathBar.element(@item_category.name, item_category_path(@item_category))]
    end

    it "should assign a path bar with nesting dish" do
      dish = stub_model(Dish, :name => "Soupe à l'oignon")
      Dish.stub(:find_by_id).and_return(dish)

      get_show(:dish_id => dish.id)

      assigns[:path_bar].should == [PathBar.element("Recettes", dish_index_path),
                                    PathBar.element(dish.name, dish_path(dish)),
                                    PathBar.element("Ingrédients", dish_item_category_index_path(dish)),
                                    PathBar.element(@item_category.name, dish_item_category_path(dish,@item_category))]
    end

    it "should assign an add item to cart link attributes" do
      get_show

      it_should_have_assigned_add_to_cart_attributes
    end

    it "should assign show sub category link params" do
      get_show

      it_should_have_assigned_show_sub_category_link_params
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

        assigns[:path_bar].should == [PathBar.element("Ingrédients", item_category_index_path),
                                      PathBar.element(@item_category.name, item_category_path(@item_category)),
                                      PathBar.element_with_no_link(@keyword)]
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
