# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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

describe ItemsController do

  ignore_user_authentication

  before :each do
    @new_item = double(Item, :id => 1, :name => "Chocolat noir à dessert")
    Item.stub(:find_by_id).with(@new_item.id.to_s).and_return(@new_item)

    @old_item = double(Item, :id => 2, :name => "Oeufs frais")
    Item.stub(:find_by_id).with(@old_item.id.to_s).and_return(@old_item)

    @dish = double(Dish, :id => 3, :name => "Gateau au chocolat", :items => [@old_item])
    @dish.stub(:save!)
    Dish.stub(:find_by_id).with(@dish.id.to_s).and_return(@dish)
  end

  [:put_create, :delete_destroy].each do |action|
    describe action do

      it "should redirect to the specified dish page" do
        self.send(action)

        expect(response).to redirect_to(dish_path(@dish))
      end

      it "should save the modified dish" do
        expect(@dish).to receive(:save!)

        self.send(action)
      end
    end
  end

  describe "put_create" do

    it "should add an item to the dish" do
      expect(@dish.items).to receive(:push).with(@new_item)

      put_create
    end

  end

  describe "delete_destroy" do

    it "should remove an item from the dish" do
      expect(@dish.items).to receive(:delete).with(@old_item)

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
