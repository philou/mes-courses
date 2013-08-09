# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'transfer_shared_examples'

describe "orders/logout" do

  it_behaves_like "a view with order transfer"

  it "renders an iframe to unlog the client from the remote store" do
    assign :order, @order = FactoryGirl.build(:order)

    render

    expect(rendered).to have_xpath("//iframe[@id='remote-store-iframe'][@src='#{@order.store_logout_url}']")
  end

end

