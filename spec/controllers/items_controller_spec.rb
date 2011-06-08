# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'


describe ItemsController do

  before :each do
    @dish = stub_model(Dish, :name => "Gateau au chocolat", :items => [])
    Dish.stub!(:find_by_id).with(@dish.id.to_s).and_return(@dish)
    @dish.stub!(:save!)

    @item = stub_model(Item, :name => "Chocolat noir à dessert")
    Item.stub!(:find_by_id).with(@item.id.to_s).and_return(@item)
  end

  it "should redirect create to the specified dish page" do
    put_create

    response.should redirect_to(dish_path(@dish.id))
  end

  it "should add an item to the dish" do
    @dish.items.should_receive(:push).with(@item)

    put_create
  end

  it "should save the modified dish" do
    @dish.should_receive(:save!)

    put_create
  end

  def put_create
    put 'create', :dish_id => @dish.id, :id => @item.id
  end

end
