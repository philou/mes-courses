require 'spec_helper'

describe DishController do

  describe 'GET index' do
    before :each do
      @all_dishes = [Dish.new(:name => "Salade de tomates"), Dish.new(:name => "Boeuf bourguignon")]
      Dish.stub(:find).and_return(@all_dishes)
    end

    it "should render 'index'" do
      get 'index'

      response.should be_success
      response.should render_template('index')
    end

    it "'index' should assign the list of all dishes to :dishes" do
      get 'index'

      assigns[:dishes].should == @all_dishes
    end

  end

  describe 'GET new' do
    it "should render 'new'" do
      get 'new'

      response.should be_success
      response.should render_template('new')
    end

    it "should assign a new dish" do
      get 'new'

      assigns[:dish].should be_instance_of(Dish)
      assigns[:dish].id.should be_nil
    end

    it "should use a nice default name for the dish" do
      get 'new'

      assigns[:dish].name.should == "Nouvelle recette"
    end
  end

  describe 'POST create' do
    before :each do
      Dish.stub!(:create!).and_return(nil)
    end

    it "should save the posted data as a new dish" do
      attributes = { "name" => "Salade grecque" }
      Dish.should_receive(:create!).with(attributes)

      post 'create', :dish => attributes
    end

    it "should redirect the main dish catalog" do
      post 'create'

      response.should redirect_to(:controller => 'dish', :action => 'index')
    end
  end

end
