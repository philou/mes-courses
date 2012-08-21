# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Items

      describe Api do

        before :each do
          Api.register_builder(my_store = "www.my-store.com", builder = stub(ApiBuilder.class))
          @url = "http://#{my_store}"
          WalkerPage.stub(:open).with(@url).and_return(walker = stub(WalkerPage))
          builder.stub(:new).with(walker).and_return(@store_api = stub(ApiBuilder))
        end

        it "select the good store items api builder to browse a store" do
          Api.browse(@url).should == @store_api
        end

        it "fails when it does not know how to browse a store" do
          lambda { Api.browse("http://unknown.store.com") }.should raise_error(NotImplementedError)
        end

      end
    end
  end
end
