# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "orders/show_success.html.erb" do

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
    response.should have_button_to("Payer sur #{@order.store.name}", @order.remote_store_order_url, 'post')
  end
  it "renders forward report warnings" do
    response.should have_selector("div", :class => "warning") do |div|
      @order.warning_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

end

