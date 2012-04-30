# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe "orders/show_success" do

  before(:each) do
    assign :order, @order = stub_model(Order, :store => stub_model(Store, :name => "www.megastore.fr",
                                                                      :sponsored_url => "http://www.affilition.com/megastore/mes-courses",
                                                                      :logout_url => "http://www.megastore.fr/logout"),
                                          :warning_notices => ["Problème de connection", "Aucun produit n'a été transféré"])
    render
  end

  it "renders a link to the online store" do
    rendered.should have_xpath("//a[@href='#{@order.store.sponsored_url}'][contains(.,'Aller vous connecter sur #{@order.store.name} pour payer')]")
  end

  it "renders forward report warnings" do
    rendered.should have_selector("div", :class => "warning") do |div|
      @order.warning_notices.each do |notice|
        div.should contain(notice)
      end
    end
  end

  it "renders an iframe to unlog the client from the remote store" do

    rendered.should have_xpath("//iframe[@id='remote-store-iframe'][@src='#{@order.store.logout_url}']")

  end

end

