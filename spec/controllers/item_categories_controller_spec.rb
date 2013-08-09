# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe ItemCategoriesController do
  include ApplicationHelper

  ignore_user_authentication

  before :each do
    ItemCategory.stub(:root).and_return(stub_model(ItemCategory, :name => ItemCategory.root_name, :items => []))

    @nesting = ItemCategoriesControllerStandaloneNesting.new
    ItemCategoriesControllerStandaloneNesting.stub(:new).and_return(@nesting)

    @dish = stub_model(Dish, :name => "Hamburger maison")
    Dish.stub(:find_by_id).and_return(@dish)
  end

  def expect_use_of_dish_nesting
    nesting = ItemCategoriesControllerDishNesting.new(@dish.id.to_s)
    expect(ItemCategoriesControllerDishNesting).to receive(:new).with(@dish.id.to_s).and_return(nesting)
    expect(ItemCategoriesControllerStandaloneNesting).not_to receive(:new)
  end

  describe "GET 'index'" do

    it "should redirect to 'show' root item category" do
      get 'index'

      expect(response).to redirect_to(item_category_path(ItemCategory.root))
    end

    it "should use a standalone nesting" do
      expect(ItemCategoriesControllerStandaloneNesting).to receive(:new)

      get 'index'
    end

    describe "with a dish" do
      it "should use a dish nesting instead of a standalone nesting" do
        expect_use_of_dish_nesting

        get 'index', :dish_id => @dish.id
      end

      it "should redirect to 'show' root item category" do
        get 'index', :dish_id => @dish.id

        expect(response).to redirect_to(dish_item_category_path(@dish, ItemCategory.root))
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

      expect(response).to be_success
      expect(response).to render_template("show")
    end

    it "should use a standalone nesting" do
      expect(ItemCategoriesControllerStandaloneNesting).to receive(:new)

      get_show
    end

    it "should assign a search url given by its nesting for the current category" do
      @nesting.stub(:item_category_path).and_return("/item_category/id=special")

      get_show

      expect(assigns(:search_url)).to eq @nesting.item_category_path
    end

    it "should assign sub categories attributes" do
      get_show

      expect(assigns(:categories)).to eq @item_category.children
    end

    it "should assign items attributes" do
      get_show

      expect(assigns(:items)).to eq @item_category.items
    end

    it "should assign a path bar starting with its nesting root path bar" do
      @nesting.stub(:root_path_bar).and_return([path_bar_dishes_root, :path_bar_2])

      get_show

      expect(assigns(:path_bar)).to be_starting_with(@nesting.root_path_bar)
    end

    it "should assign a path bar with current category" do
      get_show

      expect(assigns(:path_bar)).to be_ending_with([path_bar_items_root,
                                                path_bar_element(@item_category.name, item_category_path(@item_category))])
    end

    it "should assign a full path bar with all parents" do
      parent_category = stub_model(ItemCategory, :id => 456, :name => "Marché", :parent => ItemCategory.root)
      @item_category.stub(:parent).and_return(parent_category)

      get_show

      expect(assigns(:path_bar)).to be_ending_with([path_bar_items_root,
                                                path_bar_element(parent_category.name, item_category_path(parent_category)),
                                                path_bar_element(@item_category.name, item_category_path(@item_category))])
    end

    it "should assign an add item to cart link attributes" do
      @nesting.stub(:add_item_label).and_return("Ajouter cela ici !")
      @nesting.stub(:add_item_url_options).and_return({ :option => "trés trés importante" })
      @nesting.stub(:add_item_html_options).and_return({ :le_html => "c'est trés important" })

      get_show

      expect(assigns(:add_item_label)).to eq @nesting.add_item_label
      expect(assigns(:add_item_url_options)).to eq @nesting.add_item_url_options.stringify_keys
      expect(assigns(:add_item_html_options)).to eq @nesting.add_item_html_options.stringify_keys
    end

    it "should assign show sub category link params" do
      @nesting.stub(:show_sub_category_url_options).and_return({ :url => "http://quelque.part.com"})

      get_show

      expect(assigns(:show_sub_category_url_options)).to eq @nesting.show_sub_category_url_options.stringify_keys
    end

    describe "when showing ItemCategory root" do

      it "should assign a path_bar ending with a link to all ingredients" do
        ItemCategory.stub(:find_by_id).and_return(ItemCategory.root)

        get 'show', :id => ItemCategory.root.id

        expect(assigns(:path_bar)).to be_ending_with([path_bar_items_root])
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
        @search_string = "poulet"
        @item_category.name = "Marché"
        Item.stub(:search_string_is_valid?).and_return(true)
        Item.stub(:search_by_string_and_category).and_return([])
      end

      def get_show_search
        get 'show', :id => @item_category.id, :search => { :search_string => @search_string }
      end

      it "should assign a path_bar containing the searched category" do
        get_show_search

        expect(assigns(:path_bar)).to be_containing([path_bar_items_root,
                                                 path_bar_element(@item_category.name, item_category_path(@item_category))])
      end

      it "should assign a path_bar ending with the search" do
        get_show_search

        expect(assigns(:path_bar)).to be_ending_with([path_bar_element_with_no_link(@search_string)])
      end

      it "should assign no categories" do
        @item_category.children = [FactoryGirl.create(:item_category)]

        get_show_search

        expect(assigns(:categories)).to eq []
      end

      it "should assign searched items" do
        searched_items = [FactoryGirl.create(:item)]
        expect(Item).to receive(:search_by_string_and_category).with(@search_string, @item_category).and_return(searched_items)

        get_show_search

        expect(assigns(:items)).to eq searched_items
      end

      it "should not search with an invalid search string" do
        Item.stub(:search_string_is_valid?).and_return(false)

        expect(Item).not_to receive(:search_by_string_and_category)

        get_show_search
      end
    end
  end

end
