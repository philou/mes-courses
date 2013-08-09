# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Carts

      class WithLogout
        include WithLogoutMixin

        def logout
        end
      end

      describe WithLogoutMixin do

        before :each do
          @thing = WithLogout.new
        end

        it "should execute the given block" do
          block = nil
          @thing.with_logout do |t|
            block = :executed
          end
          expect(block).to be :executed
        end

        it "should call logout when everything went well" do
          expect(@thing).to receive(:logout).once

          @thing.with_logout {|t|}
        end

        it "should call logout even if an exception was raised" do
          expect(@thing).to receive(:logout).once
          begin
            @thing.with_logout { |t| raise RuntimeError.new }
          rescue
          end
        end

        it "should call propagate exceptions" do
          expect(lambda {
                   @thing.with_logout { |t| raise RuntimeError.new }
                 }).to raise_error(RuntimeError)
        end
      end
    end
  end
end
