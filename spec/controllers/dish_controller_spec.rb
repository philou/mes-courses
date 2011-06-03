require 'spec_helper'

describe DishController do

  describe 'GET index' do
    before :each do
      @all_dishes = [Dish.new(:name => "Salade de tomates"), Dish.new(:name => "Boeuf bourguignon")]
      Dish.stub(:find).and_return(@all_dishes)

      get 'index'
    end

    it "should render 'index'" do
      response.should be_success
      response.should render_template('index')
    end

    it "should assign the list of all dishes to :dishes" do
      assigns[:dishes].should == @all_dishes
    end

    it "should assign a path bar with a link to the root dish page" do
      assigns[:path_bar].should == [PathBar.element("Recettes", :action => 'index')]
    end

  end

  describe 'GET new' do
    before :each do
      get 'new'
    end

    it "should render 'new'" do
      response.should be_success
      response.should render_template('new')
    end

    it "should assign a new dish" do
      assigns[:dish].should be_instance_of(Dish)
      assigns[:dish].id.should be_nil
    end

    it "should use a nice default name for the dish" do
      assigns[:dish].name.should == "Nouvelle recette"
    end

    it "should assign a path bar with a link to the dish creation page" do
      assigns[:path_bar].should == [PathBar.element("Recettes", :action => 'index'),
                                    PathBar.element_for_current_resource("Nouvelle recette")]
    end
  end

  describe 'POST create' do
    before :each do
      @dish = Dish.new(:id => 1002)
      Dish.stub!(:create!).and_return(@dish)
    end

    it "should save the posted data as a new dish" do
      attributes = { "name" => "Salade grecque" }
      Dish.should_receive(:create!).with(attributes)

      post 'create', :dish => attributes
    end

    it "should redirect the main dish catalog" do
      post 'create'

      response.should redirect_to(:controller => 'dish', :action => 'show', :id => @dish.id)
    end
  end

  describe 'GET show' do

    before :each do
      @dish = Dish.new(:name => "Salade de tomates", :id => 1234)
      Dish.stub(:find_by_id).and_return(@dish)

      get 'show', :id => @dish.id
    end

    it "should render 'show'" do
      response.should be_success
      response.should render_template('show')
    end

    it "should assign the requested dish" do
      assigns[:dish].should == @dish
    end

    it "should assign a path bar with a link to the curent dish page" do
      assigns[:path_bar].should == [PathBar.element("Recettes", :action => 'index'),
                                    PathBar.element_for_current_resource(@dish.name)]
    end

  end

end
