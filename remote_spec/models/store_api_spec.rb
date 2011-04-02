# Copyright (C) 2011 by Philippe Bourgau

require 'rubygems'
require 'spec_helper'
require "selenium/client"
require "selenium/rspec/spec_helper"
require "selenium/remote_control/remote_control"
require "lib/offline_test_helper"

include OfflineTestHelper

if offline?
  puts yellow "WARNING: skipping StoreAPI remote spec because tests are running offline."

else

  describe StoreAPI do

    it "should raise when login in with an invalid account" do
      lambda {
        AuchanDirectStoreAPI.new("unknown-account", "wrong-password")
      }.should raise_error(InvalidStoreAccountError)
    end

    context "with a valid account" do

      before(:each) do
        @api = AuchanDirectStoreAPI.new(LOGIN, PASSWORD)
      end
      after(:each) do
        @api.logout
      end

      it "should set the cart value to 0 when emptying the cart" do
        @api.set_item_quantity_in_cart(1, sample_item)

        @api.empty_the_cart
        @api.value_of_the_cart.should == 0
      end

      it "should set the cart value to something greater than 0 when adding items to the cart" do
        @api.empty_the_cart

        @api.set_item_quantity_in_cart(1, sample_item)
        @api.value_of_the_cart.should >  0
      end

      it "should set the cart value to 3 times that of one item when adding 3 items" do
        @api.empty_the_cart

        @api.set_item_quantity_in_cart(1, sample_item)
        item_price = @api.value_of_the_cart

        @api.set_item_quantity_in_cart(3, sample_item)
        @api.value_of_the_cart.should == 3*item_price
      end

      it "should synchronize different sessions with logout login" do
        @api.set_item_quantity_in_cart(1, sample_item)

        AuchanDirectStoreAPI.new(LOGIN, PASSWORD).with_logout do |api2|
          api2.empty_the_cart
        end

        @api.logout
        @api = AuchanDirectStoreAPI.new(LOGIN, PASSWORD)

        @api.value_of_the_cart.should == 0
      end

      LOGIN = "philippe.bourgau@free.fr"
      PASSWORD = "NoahRules78"

      attr_reader :selenium_driver, :sample_item
      alias :store_page :selenium_driver

      before(:all) do
        start_selenium_server
        start_selenium_driver
        selenium_driver.start_new_browser_session
        begin
          @sample_item = extract_sample_item
        ensure
          selenium_driver.close_current_browser_session
        end
      end

      after(:all) do
        stop_selenium_server
      end

      private

      def extract_sample_item
        login_and do
          click_and_wait "link=Produits laitiers"
          click_and_wait "link=Laits demi-écrémés"
          click_and_wait "//a[contains(@class,'lienArticle')]"

          id = /\d+$/.match(store_page.location).to_s.to_i
          return Item.new(:name => 'Lait', :remote_id => id, :price => 5.89)
        end
      end

      def login_and
        login
        begin
          return yield

        ensure
          logout
        end
      end

      def login
        store_page.open "/frontoffice/"
        store_page.type "Username", LOGIN
        store_page.type "Password", PASSWORD
        click_and_wait "accueilIdentifier"
      end
      def logout
        click_and_wait "//img[@alt=\"Retour à l'accueil AuchanDirect\"]"
        click_and_wait "link=cliquez ici"
      end

      def click_and_wait(selector)
        store_page.click selector
        store_page.wait_for_page_to_load "5000"
      end

      HOST = "0.0.0.0"
      PORT = 4444

      def start_selenium_server
        @@remote_control = Selenium::RemoteControl::RemoteControl.new(HOST, PORT, :timeout => 60)
        @@remote_control.jar_file = Dir["vendor/selenium-remote-control/selenium-server-*.jar"].first
        @@remote_control.start :background => true
        Rails.logger.info "Waiting for Remote Control to be up and running..."
        TCPSocket.wait_for_service :host => HOST, :port => PORT
        Rails.logger.info "Selenium Remote Control at #{HOST}:#{PORT} ready"
      end

      def stop_selenium_server
        @@remote_control.stop
        Rails.logger.info "Waiting for Remote Control to stop..."
        TCPSocket.wait_for_service_termination :host => HOST, :port => PORT
        Rails.logger.info "Stopped Selenium Remote Control running at #{HOST}:#{PORT}"
      end

      def start_selenium_driver
        @selenium_driver = Selenium::Client::Driver.new \
        :host => "localhost",
        :port => PORT,
        :browser => "*firefox",
        :url => AuchanDirectStoreAPI.url,
        :timeout_in_second => 5
      end

    end

  end

end
