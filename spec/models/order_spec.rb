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

  context "when sending" do

    before :each do
      @store_session = stub(StoreCartSession).as_null_object
      StoreCartSession.stub(:login).with(@store.url, StoreCartAPI.valid_login, StoreCartAPI.valid_password).and_return(@store_session)
      class << @store_session
        include WithLogoutMixin
      end
    end

    it "should forward the cart instance to the store" do
      @cart.should_receive(:forward_to).with(@store_session, @order)

      pass_order
    end


    it "should eventually logout from the store" do
      @store_session.should_receive(:logout)

      pass_order
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

    context "when pass raises an unexpected exception" do

      before :each do
        @cart.stub(:forward_to).and_raise(SocketError.new("Connection lost"))
      end

      it "should logout from the store even if something went bad" do
        @store_session.should_receive(:logout)

        pass_order rescue nil
      end

      it "should let the exception climb up" do
        lambda { pass_order }.should raise_error(SocketError)
      end

      it "should have the FAILED status" do
        pass_order rescue nil

        @order.status.should == Order::FAILED
      end
    end

    context "when pass fails because of invalid store login and password" do
      before :each do
        @cart.stub(:forward_to).and_raise(InvalidStoreAccountError.new)
      end

      it "should not let any exception climb up" do
        lambda { pass_order }.should_not raise_error
      end

      it "should have the FAILED status" do
        pass_order

        @order.status.should == Order::FAILED
      end

      it "should have an error notice" do
        pass_order

        @order.error_notice.should == Order.invalid_store_login_notice(@store)
      end

    end
    # test invalid account => FAILED status + error_notice

    def pass_order
      @order.pass(StoreCartAPI.valid_login, StoreCartAPI.valid_password)
    end

  end


end
