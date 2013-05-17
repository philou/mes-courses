# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'spec_helper'

shared_examples "a view with order transfer" do |store_parameters = {}|

  before(:each) do
    assign :order, @order = stub_model(Order, :store => stub_model(Store, :name => "www.megastore.fr", :logout_url => "http://www.megastore.fr/logout"))
    assign :forward_completion_percents, @forward_completion_percents = 47.23
    render
  end

  it "renders the name of the store" do
    rendered.should contain(@order.store.name)
  end

  it "renders the passing progress ratio" do
    rendered.should contain('47%')
  end

end
