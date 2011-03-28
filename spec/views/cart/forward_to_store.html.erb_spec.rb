# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe "cart/forward_to_store.html.erb" do

  before(:each) do
    assigns[:store_url] = @store_url = "http://www.megastore.fr/logout"
    assigns[:report_messages] = @report_messages = ["Tout s'est bien passé.", "A bientôt."]
    render
  end

  it "renders a link to the cart view" do
    response.should have_selector("a", :href => default_path(:controller => 'cart'))
  end
  it "renders a link to the online store" do
    response.should have_selector("a", :href => @store_url)
  end
  it "renders forward report messages" do
    @report_messages.each do |message|
      response.should contain(message)
    end
  end

end

