# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
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

module MesCourses
  module Utils

    describe Retrier do

      before :each do
        @wrapped = double("UnstableDummy")
        @wrapped.stub(:throwing).and_raise(RuntimeError.new)

        @max_retries = 3
        @ignored_exception = IOError
        @sleep_delay = 10
        @options = { :max_retries => @max_retries, :ignored_exceptions => [@ignored_exception], :sleep_delay => @sleep_delay, :wrap_result => [:property, :properties] }
        @retrier = Retrier.new(@wrapped, @options)
        @retrier.stub(:sleep)
      end

      it "should forward calls to the wrapped object" do
        expect(@wrapped).to receive(:command)

        @retrier.command
      end

      it "should forward arguments to the wrapped object" do
        args = [:a, :b, :c]
        expect(@wrapped).to receive(:complex_op).with(*args)

        @retrier.complex_op(*args)
      end

      it "should return the result of the call to the wrapped object" do
        @wrapped.stub(:attribute).and_return(:raw_result)

        expect(@retrier.attribute).to eq :raw_result
      end

      context "when message is to be wrapped" do

        it "should wrap the results of in a new retrier" do
          @wrapped.stub(:property).and_return(:result)
          Retrier.stub(:new).with(:result, @options).and_return(:wrapped_result)

          expect(@retrier.property).to eq :wrapped_result
        end

        it "should not wrap nil result" do
          @wrapped.stub(:property).and_return(nil)

          expect(@retrier.property).to be_nil
        end

        it "should wrap array results in a new array of retriers" do
          properties = [:a, :b, :c]
          @wrapped.stub(:properties).and_return(properties)
          Retrier.stub(:new).with(:a, @options).and_return(:wrapped_a)
          Retrier.stub(:new).with(:b, @options).and_return(:wrapped_b)
          Retrier.stub(:new).with(:c, @options).and_return(:wrapped_c)

          expect(@retrier.properties).to eq [:wrapped_a, :wrapped_b, :wrapped_c]
        end

        it "should wrap content of enumerators" do
          integers = Enumerator.new do |yielder|
            i = 0
            loop do
              yielder << i
              i += 1
            end
          end

          @wrapped.stub(:properties).and_return(integers.lazy)

          actual = @retrier.properties
          first = [actual.next, actual.next, actual.next]
          expect(first).to all_ { be_an_instance_of(Retrier) }
          expect(first.map &:to_i).to eq [0,1,2]
        end
      end

      it "should retry the specified times in case of exception" do
        expect(@wrapped).to receive(:throwing).exactly(@max_retries).times

        expect(lambda { @retrier.throwing }).to raise_error(RuntimeError)
      end

      it "should not retry for the ignored excption" do
        expect(@wrapped).to receive(:throwing).once.and_raise(@ignored_exception.new)

        expect(lambda { @retrier.throwing }).to raise_error(@ignored_exception)
      end

      it "should wait the specified time between retries" do
        expect(@retrier).to receive(:sleep).with(@sleep_delay).exactly(@max_retries-1).times

        expect(lambda { @retrier.throwing }).to raise_error(RuntimeError)
      end

    end
  end
end
