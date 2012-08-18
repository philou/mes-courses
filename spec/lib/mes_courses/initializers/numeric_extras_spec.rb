# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses::Initializers
  describe "Numeric extras" do

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

    private

    def total_seconds(hours, minutes, seconds)
      (hours*60 + minutes)*60 + seconds
    end
  end
end
