# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module SingletonBuilderSpecMacros

  def has_singleton(symbol, value)

    singleton = described_class.send(symbol)
    factory_name = described_class.to_s.underscore.intern

    it "has a #{symbol} that is marked so" do
      singleton.should self.send("be_#{symbol}")
    end

    it "has other categories that are not #{symbol}" do
      FactoryGirl.build(factory_name).should_not self.send("be_#{symbol}")
    end

    it "publishes the name of #{symbol} directly" do
      described_class.send("#{symbol}_name").should == value
    end

    it "has a #{symbol} with a special name" do
      singleton.name.should == value
    end

  end

end
