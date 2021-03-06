# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


require 'spec_helper'

describe Store do

  # setting static constants up
  before(:each) do
    @valid_attributes = { :url => "http://www.ze-store.com", :expected_items => 10, :sponsored_url => "http://www.ze-store.com/sponsored" }

    @importer = double(MesCourses::Stores::Imports::Base).as_null_object
    MesCourses::Stores::Imports::Base.stub(:new).and_return(@importer)

    Store.stub(:maximum).with(:expected_items).and_return(0)
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  it "should ask its importer to import" do
    store = Store.new(@valid_attributes)

    browser = double("Store Items API")
    MesCourses::Stores::Items::Api.stub(:browse).and_return(browser)

    robust_browser = double(MesCourses::Utils::Retrier)
    MesCourses::Utils::Retrier.stub(:new).with(browser, anything).and_return(robust_browser)

    incremental_store = double("Incremental store")
    MesCourses::Stores::Imports::Incremental.stub(:new).with(store).and_return(incremental_store)

    expect(@importer).to receive(:import).with(robust_browser, incremental_store)

    store.import
  end

  it "should use its url host as name" do
    expect(Store.new(:url => "http://www.hard-discount-store.eco/index").name).to eq "www.hard-discount-store.eco"
  end

  context "the cart api" do
    before :each do
      @store = FactoryGirl.build(:store)
    end

    [:logout_url, :login_url, :login_parameter, :password_parameter].each do |method|
      it "knows the #{method} of the cart api" do
        expect(@store.send(method)).to eq Auchandirect::ScrAPI::DummyCart.send(method)
      end
    end
    it "knows the login parameters of the cart api" do
      credentials = FactoryGirl.build(:credentials)
      expect(@store.login_parameters(credentials)).to eq Auchandirect::ScrAPI::DummyCart.login_parameters(credentials.email, credentials.password)
    end
    it "'s login_parameters are for blank credentials by default" do
      expect(@store.login_parameters).to eq @store.login_parameters(MesCourses::Utils::Credentials.blank)
    end

    it "should yield the session to the cart api" do
      capture_result_from(Auchandirect::ScrAPI::DummyCart, :login, into: :dummy_api)

      @store.with_session(Auchandirect::ScrAPI::DummyCart.valid_email, Auchandirect::ScrAPI::DummyCart.valid_password) do |session|
        expect(session).not_to be_nil
        expect(@dummy_api.log).to include(:login)
      end

      expect(@dummy_api).not_to be_nil
      expect(@dummy_api.log).to include(:logout)
    end

  end

  context "importing all stores" do

    before :each do
      @stores = Array.new(2) { stub_model(Store) }
      @stores.each { |store| store.stub(:import) }
      Store.stub(:all).and_return(@stores)
    end

    it "should import all stores" do
      @stores.each { |store| expect(store).to receive(:import) }

      Store.import
    end

    it "update the stats first" do
      expect(ModelStat).to receive(:update!).ordered
      @stores.each { |store| expect(store).to receive(:import).ordered }

      Store.import
    end

    it "should deliver an import report email with time spent" do
      start_time = Time.local(2011, 10, 29, 16, 30, 24)
      end_time = Time.local(2011, 10, 29, 17, 48, 12)
      MesCourses::Utils::Timing.stub(:now).and_return(start_time, end_time)

      expect(ImportReporter).to receive(:delta).with(end_time - start_time, anything).and_return(email = double("Email"))
      expect(email).to receive(:deliver)

      Store.import
    end

    it "should deliver an import report email" do
      expected_items = 3000
      Store.stub(:maximum).with(:expected_items).and_return(expected_items)

      expect(ImportReporter).to receive(:delta).with(anything, expected_items).and_return(email = double("Email"))
      expect(email).to receive(:deliver)

      Store.import
    end

  end

  it "global import with an url should only import the specified store" do
    url = "http://www.discountagogo.com"

    store = stub_model(Store)
    Store.stub(:find_or_create_by_url).with(url).and_return(store)

    expect(store).to receive(:import)

    Store.import(url)
  end

end
