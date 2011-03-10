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

    it "should empty the cart" do
      login_and { make_sure_cart_is_not_empty }

      StoreAPI.with_login(StoreAPI::STORE_URL, LOGIN, PASSWORD) do |api|
        api.empty_the_cart
      end

      cart_value.should == 0.0
    end

    it "should fill in the cart" do
      make_sure_cart_is_empty
      item = sample_item

      StoreAPI.with_login(StoreAPI::STORE_URL, LOGIN, PASSWORD) do |api|
        api.set_item_quantity_in_cart(1, item)
      end
      item_price = cart_value
      item_price.should_not == 0.0

      StoreAPI.with_login(StoreAPI::STORE_URL, LOGIN, PASSWORD) do |api|
        api.set_item_quantity_in_cart(3, item)
      end
      cart_value.should == 3*item_price
    end

    it "should have a logout url to force refresh the client cart" do
      login_and do
        make_sure_cart_is_not_empty

        logout_url = StoreAPI.with_login(StoreAPI::STORE_URL, LOGIN, PASSWORD) do |api|
          api.empty_the_cart

          api.logout_url
        end

        store_page.open logout_url
        login
        current_cart_value.should == 0
      end
    end

    LOGIN = "philippe.bourgau@free.fr"
    PASSWORD = "NoahRules78"

    attr_reader :selenium_driver
    alias :store_page :selenium_driver

    before(:all) do
      start_selenium_server
      start_selenium_driver
    end

    before(:each) do
      selenium_driver.start_new_browser_session
    end

    append_after(:each) do
      selenium_driver.close_current_browser_session
    end

    after(:all) do
      stop_selenium_server
    end

    private

    def make_sure_cart_is_empty
      StoreAPI.with_login(StoreAPI::STORE_URL, LOGIN, PASSWORD) do |api|
        api.empty_the_cart
      end
    end

    def set_item_quantity_in_cart(quantity, item)
      StoreAPI.with_login(StoreAPI::STORE_URL, LOGIN, PASSWORD) do |api|
        api.set_item_quantity_in_cart(quantity, item)
        return api.logout_url
      end
    end

    def make_sure_cart_is_not_empty
      click_and_wait "link=Produits laitiers"
      click_and_wait "link=Laits demi-écrémés"
      store_page.click "//img[@alt='Ajouter au panier']"
      current_cart_value.should_not == 0.0
    end

    def sample_item
      login_and do
        click_and_wait "link=Produits laitiers"
        click_and_wait "link=Laits demi-écrémés"
        click_and_wait "//a[contains(@class,'lienArticle')]"

        id = /\d+$/.match(store_page.location).to_s.to_i
        return Item.new(:name => 'Lait', :remote_id => id, :price => 5.89)
      end
    end

    def cart_value
      login_and do
        current_cart_value
      end
    end

    def current_cart_value
      store_page.get_text("panier_prix").delete('€').strip.to_f
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
      :url => StoreAPI::STORE_URL,
      :timeout_in_second => 5
    end

  end

end
