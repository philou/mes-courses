# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe ItemsController do

  before :each do
    @new_item = stub_model(Item, :name => "Chocolat noir à dessert")
    Item.stub!(:find_by_id).with(@new_item.id.to_s).and_return(@new_item)

    @old_item = stub_model(Item, :name => "Oeufs frais")
    Item.stub!(:find_by_id).with(@old_item.id.to_s).and_return(@old_item)

    @dish = stub_model(Dish, :name => "Gateau au chocolat", :items => [@old_item])
    Dish.stub!(:find_by_id).with(@dish.id.to_s).and_return(@dish)
    @dish.stub!(:save!)
  end

  [:put_create, :delete_destroy].each do |action|
    describe action do

      it "should redirect to the specified dish page" do
        self.send(action)

        response.should redirect_to(dish_path(@dish.id))
      end

      it "should save the modified dish" do
        @dish.should_receive(:save!)

        self.send(action)
      end
    end
  end

  describe "put_create" do

    it "should add an item to the dish" do
      @dish.items.should_receive(:push).with(@new_item)

      put_create
    end

  end

  describe "delete_destroy" do

    it "should remove an item from the dish" do
      @dish.items.should_receive(:delete).with(@old_item)

      delete_destroy
    end

  end

  def put_create
    put 'create', :dish_id => @dish.id, :id => @new_item.id
  end

  def delete_destroy
    delete 'destroy', :dish_id => @dish.id, :id => @old_item.id
  end

end
