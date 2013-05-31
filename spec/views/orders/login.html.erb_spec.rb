# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe "orders/login" do

  before(:each) do
    assign :order, @order = FactoryGirl.build(:order)
    assign :store_credentials, @credentials = FactoryGirl.build(:credentials)
  end

  it "renders the login form to the online store" do
    render

    rendered.should contain("Connectez-vous sur #{@order.store_name} pour payer")
    rendered.should include(@order.store_login_form_html(@credentials))
  end

  it "renders forward report warnings" do
    2.times { @order.add_missing_cart_line(FactoryGirl.build(:cart_line)) }

    render

    rendered.should have_selector("div", :class => "warning") do |div|
      @order.warning_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

end

