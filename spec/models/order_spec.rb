# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

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

    @order.warning_notices.should == [Order.missing_cart_line_notice(@cart_line_1, @store),
                                      Order.missing_cart_line_notice(@cart_line_2, @store)]
  end

  it "should increase the forwarded cart lines count when notified" do
    [1,2].each do |i|
      @order.notify_forwarded_cart_line
      @order.forwarded_cart_lines_count.should == i
    end
  end

  context "when passing" do

    before :each do
      @order.stub(:save!)
      @store_session = stub(MesCourses::StoreCarts::StoreCartSession).as_null_object
      MesCourses::StoreCarts::StoreCart.stub(:for_url).with(@store.url).and_return(store_cart = stub(MesCourses::StoreCarts::StoreCart))
      store_cart.stub(:login).with(MesCourses::StoreCarts::StoreCartAPI.valid_login, MesCourses::StoreCarts::StoreCartAPI.valid_password).and_return(@store_session)
      class << @store_session
        include MesCourses::StoreCarts::WithLogoutMixin
      end
    end

    it "should forward the cart instance to the store" do
      @cart.should_receive(:forward_to).with(@store_session, @order)

      pass_order
    end

    it "should logout from the store" do
      it_should_logout_from_the_store
    end

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
      it_aborts_passing_orders_on(InvalidStoreAccountError.new)

      it "should not let any exception climb up" do
        lambda { pass_order }.should_not raise_error
      end

      it "should have an error notice" do
        pass_order

        @order.error_notice.should == Order.invalid_store_login_notice(@store)
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
      @order.pass(MesCourses::StoreCarts::StoreCartAPI.valid_login, MesCourses::StoreCarts::StoreCartAPI.valid_password)
    end
  end
end
