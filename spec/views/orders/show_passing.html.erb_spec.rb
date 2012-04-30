# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "orders/show_passing" do

  before(:each) do
    assign :order, @order = stub_model(Order, :store => stub_model(Store, :name => "www.megastore.fr"))
    assign :forward_completion_percents, @forward_completion_percents = 47.23
    render
  end

  it "should render the name of the store" do
    rendered.should contain(@order.store.name)
  end

  it "should render the passing progress ratio" do
    rendered.should contain('47%')
  end

end

