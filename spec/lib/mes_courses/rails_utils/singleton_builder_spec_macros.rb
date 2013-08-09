# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module RailsUtils
    module SingletonBuilderSpecMacros

      def has_singleton(symbol, value)

        singleton = described_class.send(symbol)
        factory_name = described_class.to_s.underscore.intern

        it "has a #{symbol} that is marked so" do
          expect(singleton).to self.send("be_#{symbol}")
        end

        it "has other categories that are not #{symbol}" do
          expect(FactoryGirl.build(factory_name)).not_to self.send("be_#{symbol}")
        end

        it "publishes the name of #{symbol} directly" do
          expect(described_class.send("#{symbol}_name")).to eq value
        end

        it "has a #{symbol} with a special name" do
          expect(singleton.name).to eq value
        end
      end
    end
  end
end
