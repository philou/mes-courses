# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses::StoreCarts

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
      block.should be :executed
    end

    it "should call logout when everything went well" do
      @thing.should_receive(:logout).once

      @thing.with_logout {|t|}
    end

    it "should call logout even if an exception was raised" do
      @thing.should_receive(:logout).once
      begin
        @thing.with_logout { |t| raise RuntimeError.new }
      rescue
      end
    end

    it "should call propagate exceptions" do
      lambda {
        @thing.with_logout { |t| raise RuntimeError.new }
      }.should raise_error(RuntimeError)
    end
  end
end
