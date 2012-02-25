# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "orders/show_passing.html.erb" do

  before(:each) do
    assigns[:order] = @order = stub_model(Order, :store => stub_model(Store, :name => "www.megastore.fr"))
    assigns[:forward_completion_percents] = @forward_completion_percents = 47.23
    render
  end

  it "should render the name of the store" do
    response.should contain(@order.store.name)
  end

  it "should render the passing progress ratio" do
    response.should contain('47%')
  end

end

