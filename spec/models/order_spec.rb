# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe Order do

  before :each do
    @order = FactoryGirl.build(:order)
    @store = @order.store
    @cart = @order.cart
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
    @order.add_missing_cart_line(@cart_line_1 = FactoryGirl.build(:cart_line, item: FactoryGirl.build(:item, name: "Tomates")))
    @order.add_missing_cart_line(@cart_line_2 = FactoryGirl.build(:cart_line, item: FactoryGirl.build(:item, name: "Steak")))

    @order.warning_notices.should == [Order.missing_cart_line_notice(@cart_line_1.name, @store.name),
                                      Order.missing_cart_line_notice(@cart_line_2.name, @store.name)]
  end

  it "forwards store name to the store" do
    @order.store_name.should == @store.name
  end

  it "forwards logout url to the store" do
    expect(@order.store_logout_url).to eq(@store.logout_url)
  end

  it "forwards login url to the store" do
    expect(@order.store_login_url).to eq(@store.login_url)
  end

  it "forwards login parameters to the store" do
    credentials = FactoryGirl.build(:credentials)
    @order.store_login_parameters(credentials).should == @store.login_parameters(credentials)
  end

  context "passed ratio" do

    before :each do
      @order.created_at = (@start_time = Time.now)
      @cart.lines = FactoryGirl.build_list(:cart_line, 7)
    end

    it "should be 100% if the order is empty" do
      @cart.lines = []

      @order.passed_ratio.should == 1.0
    end

    it "should depend on the start time before lines are transfered" do
      Timecop.freeze(@start_time + 15)

      @order.passed_ratio.should be_within(1e-8).of(Order::PASSED_RATIO_BEFORE * 15.0 / 60.0)
    end

    it "should be 0 if the order was not saved" do
      @order.created_at = nil

      @order.passed_ratio.should == 0.0
    end

    it "should caped before cart lines are transfered" do
      Timecop.freeze(@start_time + 75)

      @order.passed_ratio.should == Order::PASSED_RATIO_BEFORE
    end

    it "should be computed from forwarded cart lines" do
      4.times { @order.notify_forwarded_cart_line }

      @order.passed_ratio.should == Order::PASSED_RATIO_BEFORE + Order::PASSED_RATIO_DURING*(4.0 / 7.0)
    end

  end

  context "when passing" do

    before :each do
      capture_result_from(MesCourses::Stores::Carts::DummyApi, :login, into: :api)
    end

    it "should forward the cart instance to the store" do
      @cart.should_receive(:forward_to).with(instance_of(MesCourses::Stores::Carts::Session), @order)

      pass_order
    end

    it "should logout from the store" do
      it_should_logout_from_the_store
    end

    it "should have the PASSING status when it is beeing passed" do
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
      pass_order rescue nil

      @api.log.last.should == :logout
    end

    def it_should_eventually_save_the_order
      pass_order rescue nil

      @order.should_not be_new_record
    end

    def pass_order
      @order.pass(FactoryGirl.build(:valid_credentials))
    end
  end
end
