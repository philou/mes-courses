# -*- encoding: utf-8 -*-
require 'spec_helper'

describe DishesController do
  include PathBarHelper

  ignore_user_authentication

  def self.allows_dish_modifications_for_signed_in_users_only(&http_request_proc)

    it "should forbid dish modifications by default" do
      instance_eval(&http_request_proc)

      assigns(:can_modify_dishes).should == false
    end

    it "should let signed in users modify dishes" do
      stub_signed_in_user

      instance_eval(&http_request_proc)

      assigns(:can_modify_dishes).should == true
    end

  end

  describe 'GET index' do
    before :each do
      @all_dishes = [Dish.new(:name => "Salade de tomates"), Dish.new(:name => "Boeuf bourguignon")]
      Dish.stub(:all).and_return(@all_dishes)
    end

    it "should render 'index'" do
      get 'index'

      response.should be_success
      response.should render_template('index')
    end

    it "should publish the list of all dishes" do
      get 'index'

      assigns(:dishes).should == @all_dishes
    end

    it "should create a path bar with a link to the root dish page" do
      get 'index'

      assigns(:path_bar).should == [path_bar_dishes_root]
    end

    allows_dish_modifications_for_signed_in_users_only { get 'index' }

  end

  describe 'GET new' do
    before :each do
      get 'new'
    end

    it "should render 'new'" do
      response.should be_success
      response.should render_template('new')
    end

    it "should publish a new dish" do
      assigns(:dish).should be_instance_of(Dish)
      assigns(:dish).id.should be_nil
    end

    it "should use a nice default name for the dish" do
      assigns(:dish).name.should == "Nouvelle recette"
    end

    it "should create a path bar with a link to the dish creation page" do
      assigns(:path_bar).should == [path_bar_dishes_root,
                                    path_bar_element_for_current_resource("Nouvelle recette")]
    end
  end

  describe 'POST create' do
    before :each do
      @dish = stub_model(Dish)
      Dish.stub!(:create!).and_return(@dish)
    end

    it "should save the posted data as a new dish" do
      attributes = { "name" => "Salade grecque" }
      Dish.should_receive(:create!).with(attributes)

      post 'create', :dish => attributes
    end

    it "should redirect the main dish catalog" do
      post 'create'

      response.should redirect_to(:controller => 'dishes', :action => 'show', :id => @dish.id)
    end
  end

  describe 'GET show' do

    before :each do
      @dish = stub_model(Dish, :name => "Salade de tomates")
      Dish.stub(:find_by_id).and_return(@dish)

    end

    it "should render 'show'" do
      get 'show', :id => @dish.id

      response.should be_success
      response.should render_template('show')
    end

    it "should publish the requested dish" do
      get 'show', :id => @dish.id

      assigns(:dish).should == @dish
    end

    it "should create a path bar with a link to the curent dish page" do
      get 'show', :id => @dish.id

      assigns(:path_bar).should == [path_bar_dishes_root,
                                    path_bar_element_for_current_resource(@dish.name)]
    end

    allows_dish_modifications_for_signed_in_users_only { get 'show', :id => @dish.id }
  end

end
