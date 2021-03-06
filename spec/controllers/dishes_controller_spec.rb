# -*- encoding: utf-8 -*-
# Copyright (C) 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


require 'spec_helper'

describe DishesController do
  include PathBarHelper

  ignore_user_authentication

  def self.allows_dish_modifications_for_signed_in_users_only(&http_request_proc)

    it "should forbid dish modifications by default" do
      instance_eval(&http_request_proc)

      expect(assigns(:can_modify_dishes)).to eq false
    end

    it "should let signed in users modify dishes" do
      stub_signed_in_user

      instance_eval(&http_request_proc)

      expect(assigns(:can_modify_dishes)).to eq true
    end

  end

  describe 'GET index' do
    before :each do
      @all_dishes = [Dish.new(:name => "Salade de tomates"), Dish.new(:name => "Boeuf bourguignon")]
      Dish.stub(:all).and_return(@all_dishes)
    end

    it "should render 'index'" do
      get 'index'

      expect(response).to be_success
      expect(response).to render_template('index')
    end

    it "should publish the list of all dishes" do
      get 'index'

      expect(assigns(:dishes)).to eq @all_dishes
    end

    it "should create a path bar with a link to the root dish page" do
      get 'index'

      expect(assigns(:path_bar)).to eq [path_bar_dishes_root]
    end

    allows_dish_modifications_for_signed_in_users_only { get 'index' }

  end

  describe 'GET new' do
    before :each do
      get 'new'
    end

    it "should render 'new'" do
      expect(response).to be_success
      expect(response).to render_template('new')
    end

    it "should publish a new dish" do
      expect(assigns(:dish)).to be_instance_of(Dish)
      expect(assigns(:dish).id).to be_nil
    end

    it "should use a nice default name for the dish" do
      expect(assigns(:dish).name).to eq "Nouvelle recette"
    end

    it "should create a path bar with a link to the dish creation page" do
      expect(assigns(:path_bar)).to eq [path_bar_dishes_root,
                                    path_bar_element_for_current_resource("Nouvelle recette")]
    end
  end

  describe 'POST create' do
    before :each do
      @dish = stub_model(Dish)
      Dish.stub(:create!).and_return(@dish)
    end

    it "should save the posted data as a new dish" do
      attributes = { "name" => "Salade grecque" }
      expect(Dish).to receive(:create!).with(attributes)

      post 'create', :dish => attributes
    end

    it "should redirect the main dish catalog" do
      post 'create'

      expect(response).to redirect_to(:controller => 'dishes', :action => 'show', :id => @dish.id)
    end
  end

  describe 'GET show' do

    before :each do
      @dish = stub_model(Dish, :name => "Salade de tomates")
      Dish.stub(:find_by_id).and_return(@dish)

    end

    it "should render 'show'" do
      get 'show', :id => @dish.id

      expect(response).to be_success
      expect(response).to render_template('show')
    end

    it "should publish the requested dish" do
      get 'show', :id => @dish.id

      expect(assigns(:dish)).to eq @dish
    end

    it "should create a path bar with a link to the curent dish page" do
      get 'show', :id => @dish.id

      expect(assigns(:path_bar)).to eq [path_bar_dishes_root,
                                    path_bar_element_for_current_resource(@dish.name)]
    end

    allows_dish_modifications_for_signed_in_users_only { get 'show', :id => @dish.id }
  end

end
