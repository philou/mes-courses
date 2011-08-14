# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "orders/show.html.erb" do

  before(:each) do
    assigns[:order] = @order = stub_model(Order, :store => stub_model(Store, :name => "www.megastore.fr"),
                                                 :remote_store_order_url => "http://www.megastore.fr/logout",
                                                 :warning_notices => ["Problème de connection", "Aucun produit n'a été transféré"])
    render
  end

  it "renders a link to the cart view" do
    response.should have_selector("a", :href => cart_lines_path)
  end
  it "renders a link to the online store" do
    response.should have_selector("form", :action => @order.remote_store_order_url) do |form|
      form.should have_selector('input', :type => 'submit', :value => "Payer sur #{@order.store.name}")
    end
  end
  it "renders forward report notices" do
    response.should have_selector("div", :class => "notice") do |div|
      @order.warning_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

end

