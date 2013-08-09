# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe Dish do

  before :each do
    @dish = Dish.new()
    @dish.items = FactoryGirl.build_list(:item, 2)
  end

  it "is currently not disabled" do
    expect(@dish).not_to be_disabled
  end

  it "is disabled if one of its items is disabled" do
    @dish.items << FactoryGirl.build(:item).that_is_disabled

    expect(@dish).to be_disabled
  end

end
