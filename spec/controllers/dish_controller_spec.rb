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

  it "should render 'new'" do
    get 'new'

    response.should be_success
    response.should render_template('new')
  end

end
