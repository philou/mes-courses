# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require 'mes_courses/store_carts/store_cart'

describe StoreCart do

  before :each do
    url = "http://www.mega-store.fr"
    StoreCartAPI.stub(:for_url).with(url).and_return(@store_api_class = stub("StoreCartAPI class"))
    @store_api_class.stub(:login).and_return(@store_api = stub(StoreCartAPI))
    @store_api_class.stub(:logout_url).and_return(url+"/logout")
    StoreCartSession.stub(:new).with(@store_api).and_return(@store_session = stub(StoreCartSession))

    @store_cart = StoreCart.for_url(url)
  end

  it "should create a session wrapper on a loged in cart api" do
    @store_cart.login('valid_login', 'valid_password').should == @store_session
  end

  it "should know the logout_url of the api" do
    @store_cart.logout_url.should == @store_api_class.logout_url
  end

end
