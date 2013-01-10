# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Utils

    describe Retrier do

      before :each do
        @wrapped = stub("UnstableDummy")
        @wrapped.stub(:throwing).and_raise(RuntimeError.new)

        @max_retries = 3
        @ignored_exception = IOError
        @sleep_delay = 10
        @options = { :max_retries => @max_retries, :ignored_exceptions => [@ignored_exception], :sleep_delay => @sleep_delay, :wrap_result => [:property, :properties] }
        @retrier = Retrier.new(@wrapped, @options)
        @retrier.stub(:sleep)
      end

      it "should forward calls to the wrapped object" do
        @wrapped.should_receive(:command)

        @retrier.command
      end

      it "should forward arguments to the wrapped object" do
        args = [:a, :b, :c]
        @wrapped.should_receive(:complex_op).with(*args)

        @retrier.complex_op(*args)
      end

      it "should return the result of the call to the wrapped object" do
        @wrapped.stub(:attribute).and_return(:raw_result)

        @retrier.attribute.should == :raw_result
      end

      context "when message is to be wrapped" do

        it "should wrap the results of in a new retrier" do
          @wrapped.stub(:property).and_return(:result)
          Retrier.stub(:new).with(:result, @options).and_return(:wrapped_result)

          @retrier.property.should == :wrapped_result
        end

        it "should not wrap nil result" do
          @wrapped.stub(:property).and_return(nil)

          @retrier.property.should be_nil
        end

        it "should wrap array results in a new array of retriers" do
          properties = [:a, :b, :c]
          @wrapped.stub(:properties).and_return(properties)
          Retrier.stub(:new).with(:a, @options).and_return(:wrapped_a)
          Retrier.stub(:new).with(:b, @options).and_return(:wrapped_b)
          Retrier.stub(:new).with(:c, @options).and_return(:wrapped_c)

          @retrier.properties.should == [:wrapped_a, :wrapped_b, :wrapped_c]
        end

        it "should wrap content of enumerators" do
          integers = Enumerator.new do |yielder|
            i = 0
            loop do
              yielder << i
              i += 1
            end
          end

          @wrapped.stub(:properties).and_return(integers)

          actual = @retrier.properties
          first = [actual.next, actual.next, actual.next]
          first.should all_do be_an_instance_of(Retrier)
          (first.map &:to_i).should == [0,1,2]
        end
      end

      it "should retry the specified times in case of exception" do
        @wrapped.should_receive(:throwing).exactly(@max_retries).times

        lambda { @retrier.throwing }.should raise_error(RuntimeError)
      end

      it "should not retry for the ignored excption" do
        @wrapped.should_receive(:throwing).once.and_raise(@ignored_exception.new)

        lambda { @retrier.throwing }.should raise_error(@ignored_exception)
      end

      it "should wait the specified time between retries" do
        @retrier.should_receive(:sleep).with(@sleep_delay).exactly(@max_retries-1).times

        lambda { @retrier.throwing }.should raise_error(RuntimeError)
      end

    end
  end
end
