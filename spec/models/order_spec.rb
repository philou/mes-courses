# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe Order do

  before :each do
    @cart = Cart.new()
    @store = Store.new(:url => "http://www.funny-store.com")
    @order = Order.new(:cart => @cart, :store => @store)
  end

  it "should not have any warning notice by default" do
    @order.warning_notices.should be_empty
  end

  it "should have a blank error notice by default" do
    @order.error_notice.should == ""
  end

  it "should assign 0 forwarded cart lines count by default" do
    @order.forwarded_cart_lines_count.should == 0
  end

  it "should have the NOT_SENT status by default" do
    @order.status.should == Order::NOT_PASSED
  end

  it "should extend warning notices when missing cart lines are added" do
    @order.add_missing_cart_line(@cart_line_1 = stub_model(CartLine, :name => "Tomates"))
    @order.add_missing_cart_line(@cart_line_2 = stub_model(CartLine, :name => "Steak"))

    @order.warning_notices.should == [Order.missing_cart_line_notice(@cart_line_1.name, @store.name),
                                      Order.missing_cart_line_notice(@cart_line_2.name, @store.name)]
  end

  context "passed ratio" do

    before :each do
      @cart.stub(:lines).and_return(Array.new(7, stub_model(CartLine)))
      @order.stub(:created_at).and_return(@start_time = Time.now - 15)
    end

    it "should be 100% if the order is empty" do
      @cart.stub(:lines).and_return([])

      @order.passed_ratio.should == 1.0
    end

    it "should depend on the start time before lines are transfered" do
      @order.passed_ratio.should be_within(1e-2).of(0.15 * (Time.now - @start_time) / 60.0)
    end

    it "should be 0 if the order was not saved" do
      @order.stub(:created_at).and_return(nil)

      @order.passed_ratio.should == 0.0
    end

    it "should be computed from forwarded cart lines" do
      4.times { @order.notify_forwarded_cart_line }

      @order.passed_ratio.should == 0.15 + 0.85*(4.0 / 7.0)
    end

  end

  context "when passing" do

    before :each do
      @order.stub(:save!)
      @store_session = stub(MesCourses::Stores::Carts::Session).as_null_object
      MesCourses::Stores::Carts::Base.stub(:for_url).with(@store.url).and_return(store_cart = stub(MesCourses::Stores::Carts::Base))
      store_cart.stub(:login).with(MesCourses::Stores::Carts::Api.valid_login, MesCourses::Stores::Carts::Api.valid_password).and_return(@store_session)
      class << @store_session
        include MesCourses::Stores::Carts::WithLogoutMixin
      end
    end

    it "should forward the cart instance to the store" do
      @cart.should_receive(:forward_to).with(@store_session, @order)

      pass_order
    end

    it "should logout from the store" do
      it_should_logout_from_the_store
    end
!
    it "should have the SENDING status when it is beeing passed" do
      @cart.stub(:forward_to).with do |session, order|
        @order.status.should == Order::PASSING
      end

      pass_order
    end

    it "should have the SUCCEEDED status after it is passed" do
      pass_order

      @order.status.should == Order::SUCCEEDED
    end

    it "should eventually save the order" do
      it_should_eventually_save_the_order
    end

    def self.it_aborts_passing_orders_on(exception)

      before :each do
        @cart.stub(:forward_to).and_raise(exception)
      end

      it "should logout from the store" do
        it_should_logout_from_the_store
      end

      it "should have the FAILED status" do
        pass_order rescue nil

        @order.status.should == Order::FAILED
      end

      it "should eventually save the order" do
        it_should_eventually_save_the_order
      end
    end

    context "when pass raises an unexpected exception" do
      it_aborts_passing_orders_on(SocketError.new("Connection lost"))

      it "should let the exception climb up" do
        lambda { pass_order }.should raise_error(SocketError)
      end
    end

    context "when pass fails because of invalid store login and password" do
      it_aborts_passing_orders_on(MesCourses::Stores::Carts::InvalidAccountError.new)

      it "should not let any exception climb up" do
        lambda { pass_order }.should_not raise_error
      end

      it "should have an error notice" do
        pass_order

        @order.error_notice.should == Order.invalid_store_login_notice(@store.name)
      end
    end

    def it_should_logout_from_the_store
      @cart.should_receive(:forward_to).ordered
      @store_session.should_receive(:logout).ordered

      pass_order rescue nil
    end

    def it_should_eventually_save_the_order
      @order.should_receive(:status=).twice.ordered
      @order.should_receive(:save!).ordered

      pass_order rescue nil
    end

    def pass_order
      @order.pass(MesCourses::Stores::Carts::Api.valid_login, MesCourses::Stores::Carts::Api.valid_password)
    end
  end
end
