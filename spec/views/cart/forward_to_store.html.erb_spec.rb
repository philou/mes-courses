# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "cart/forward_to_store.html.erb" do

  before(:each) do
    assigns[:store] = stub_model(Store, :name => "www.megastore.fr")
    assigns[:store_logout_url] = @store_logout_url = "http://www.megastore.fr/logout"
    assigns[:report_notices] = @report_notices = ["Problème de connection", "Aucun produit n'a été transféré"]
    render
  end

  it "renders a link to the cart view" do
    response.should have_selector("a", :href => default_path(:controller => 'cart'))
  end
  it "renders a link to the online store" do
    response.should have_selector("form", :action => @store_logout_url)
  end
  it "renders forward report notices" do
    response.should have_selector("div", :class => "notice") do |div|
      @report_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

end

