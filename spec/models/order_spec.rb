# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013, 2014 by Philippe Bourgau

require 'spec_helper'

describe Order do

  before :each do
    @order = FactoryGirl.build(:order)
    @store = @order.store
    @cart = @order.cart
  end

  it "should not have any warning notice by default" do
    expect(@order.warning_notices).to be_empty
  end

  it "should have a blank error notice by default" do
    expect(@order.error_notice).to eq ""
  end

  it "should assign 0 forwarded cart lines count by default" do
    expect(@order.forwarded_cart_lines_count).to eq 0
  end

  it "should have the NOT_SENT status by default" do
    expect(@order.status).to eq Order::NOT_PASSED
  end

  it "should extend warning notices when missing cart lines are added" do
    @order.add_missing_cart_line(@cart_line_1 = FactoryGirl.build(:cart_line, item: FactoryGirl.build(:item, name: "Tomates")))
    @order.add_missing_cart_line(@cart_line_2 = FactoryGirl.build(:cart_line, item: FactoryGirl.build(:item, name: "Steak")))

    expect(@order.warning_notices).to eq [Order.missing_cart_line_notice(@cart_line_1.name, @store.name),
                                      Order.missing_cart_line_notice(@cart_line_2.name, @store.name)]
  end

  [:name, :logout_url, :login_url, :login_parameter, :password_parameter].each do |method|
    it "forwards store #{method} to the store" do
      expect(@order.send("store_#{method}")).to eq @store.send(method)
    end
  end

  it "forwards login parameters to the store" do
    credentials = FactoryGirl.build(:credentials)
    expect(@order.store_login_parameters(credentials)).to eq @store.login_parameters(credentials)
  end



  context "passed ratio" do

    before :each do
      @order.created_at = (@start_time = Time.now)
      @cart.lines = FactoryGirl.build_list(:cart_line, 7)
    end

    it "should be 100% if the order is empty" do
      @cart.lines = []

      expect(@order.passed_ratio).to eq 1.0
    end

    it "should depend on the start time before lines are transfered" do
      Timecop.freeze(@start_time + 15)

      expect(@order.passed_ratio).to be_within(1e-8).of(Order::PASSED_RATIO_BEFORE * 15.0 / 60.0)
    end

    it "should be 0 if the order was not saved" do
      @order.created_at = nil

      expect(@order.passed_ratio).to eq 0.0
    end

    it "should caped before cart lines are transfered" do
      Timecop.freeze(@start_time + 75)

      expect(@order.passed_ratio).to eq Order::PASSED_RATIO_BEFORE
    end

    it "should be computed from forwarded cart lines" do
      4.times { @order.notify_forwarded_cart_line }

      expect(@order.passed_ratio).to eq Order::PASSED_RATIO_BEFORE + Order::PASSED_RATIO_DURING*(4.0 / 7.0)
    end

    it "should save cart line forwarding progress" do
      expect(@order).to be_new_record

      @order.notify_forwarded_cart_line

      expect(@order).not_to be_new_record
    end

  end

  context "when passing" do

    before :each do
      capture_result_from(Auchandirect::ScrAPI::DummyCart, :login, into: :api)
    end

    it "should forward the cart instance to the store" do
      expect(@cart).to receive(:forward_to).with(instance_of(MesCourses::Stores::Carts::Session), @order)

      pass_order
    end

    it "should logout from the store" do
      it_should_logout_from_the_store
    end

    it "should have the PASSING status when it is beeing passed" do
      @cart.stub(:forward_to).with do |session, order|
        expect(@order.status).to eq Order::PASSING
      end

      pass_order
    end

    it "should have the SUCCEEDED status after it is passed" do
      pass_order

      expect(@order.status).to eq Order::SUCCEEDED
    end

    it "should eventually save the order" do
      it_should_eventually_save_the_order
    end

    it "sends an order memo to the user" do
      pass_order

      expect(mailbox_for(@credentials.email)).to include_email_with_subject(OrderMailer::MEMO_SUBJECT)
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

        expect(@order.status).to eq Order::FAILED
      end

      it "should eventually save the order" do
        it_should_eventually_save_the_order
      end
    end

    context "when pass raises an unexpected exception" do
      it_aborts_passing_orders_on(SocketError.new("Connection lost"))

      it "should let the exception climb up" do
        expect(lambda { pass_order }).to raise_error(SocketError)
      end
    end

    context "when pass fails because of invalid store login and password" do
      it_aborts_passing_orders_on(Auchandirect::ScrAPI::InvalidAccountError.new)

      it "should not let any exception climb up" do
        expect(lambda { pass_order }).not_to raise_error
      end

      it "should have an error notice" do
        pass_order

        expect(@order.error_notice).to eq Order.invalid_store_login_notice(@store.name)
      end

      it "does not send any email" do
        pass_order

        expect(all_emails).to be_empty
      end
    end

    def it_should_logout_from_the_store
      pass_order rescue nil

      expect(@api.log.last).to eq :logout
    end

    def it_should_eventually_save_the_order
      pass_order rescue nil

      expect(@order).not_to be_new_record
    end

    def pass_order
      @order.pass(@credentials = FactoryGirl.build(:valid_credentials))
    end
  end
end
