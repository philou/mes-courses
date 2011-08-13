# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "cart_lines/forward_to_store.html.erb" do

  before(:each) do
    assigns[:store] = stub_model(Store, :name => "www.megastore.fr")
    assigns[:remote_store_order_url] = @remote_store_order_url = "http://www.megastore.fr/logout"
    assigns[:forward_notices] = @forward_notices = ["Problème de connection", "Aucun produit n'a été transféré"]
    render
  end

  it "renders a link to the cart view" do
    response.should have_selector("a", :href => cart_lines_path)
  end
  it "renders a link to the online store" do
    response.should have_selector("form", :action => @remote_store_order_url) do |form|
      form.should have_selector('input', :type => 'submit', :value => "Payer sur www.megastore.fr")
    end
  end
  it "renders forward report notices" do
    response.should have_selector("div", :class => "notice") do |div|
      @forward_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

end

