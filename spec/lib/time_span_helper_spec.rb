# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'lib/time_span_helper'

describe "Timing" do

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
      timer.seconds.should == 10

      wait(5)
      timer.seconds.should == 15
    end
  end

  context "when pretty printing seconds as a duration" do

    it "should print the number of seconds" do
      15.to_pretty_duration.should == "0h 0m 15s"
    end

    it "should ignore milliseconds" do
      (1.123).to_pretty_duration.should == "0h 0m 1s"
    end

    it "should print hours and minutes" do
      total_seconds(8,23,17).to_pretty_duration.should == "8h 23m 17s"
    end

    it "should convert days to hours" do
      total_seconds(48,0, 0).to_pretty_duration.should == "48h 0m 0s"
    end

  end

  private

  def total_seconds(hours, minutes, seconds)
    (hours*60 + minutes)*60 + seconds
  end

  def wait(seconds)
    now = Timing.now
    Timing.stub(:now).and_return(now + seconds)
  end

end
