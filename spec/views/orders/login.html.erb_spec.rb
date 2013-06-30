# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe "orders/login" do

  before(:each) do
    assign :order, @order = FactoryGirl.build(:order)
    assign :store_login_parameters, @store_login_parameters = @order.store_login_parameters(FactoryGirl.build(:credentials))
  end

  it "renders the login form to the online store" do
    render

    expect(response).to have_selector("form", action: @order.store_login_url, method: 'post') do |form|
      @store_login_parameters.each do |name, value|
        form.should have_selector("input", type: 'hidden', name: name, value: value)
      end
      form.should have_selector("input", type: 'submit', value: "Connectez-vous sur #{@order.store_name} pour payer")
    end
  end

  it "renders forward report warnings" do
    2.times { @order.add_missing_cart_line(FactoryGirl.build(:cart_line)) }

    render

    rendered.should have_selector("div", class: "warning") do |div|
      @order.warning_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

end
