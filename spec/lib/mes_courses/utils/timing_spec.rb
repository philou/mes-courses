# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Utils

    describe Timing do

      before :each do
        Timing.stub(:now).and_return(Time.local(2011, 11, 15, 20, 0, 0, 0))
      end

      it "should invoke the given block" do
        should_receive(:processing)

        Timing.duration_of do
          processing
        end
      end

      it "should provide the total duration to the given block" do
        Timing.duration_of do |timer|
          wait(10)
          expect(timer.seconds).to eq 10

          wait(5)
          expect(timer.seconds).to eq 15
        end
      end

      private

      def wait(seconds)
        now = Timing.now
        Timing.stub(:now).and_return(now + seconds)
      end
    end
  end
end
