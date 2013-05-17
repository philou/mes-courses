# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module HtmlUtils
    describe PageRefreshStrategy do

      it "default to refresh every 3 seconds" do
        PageRefreshStrategy.new.to_html.should == '<meta http-equiv="refresh" content="3" />'
      end

      it "can be nil and emits no html" do
        PageRefreshStrategy.none.to_html.should == ''
      end

      it "can have a different refresh interval" do
        PageRefreshStrategy.new(interval: 5).to_html.should == '<meta http-equiv="refresh" content="5" />'
      end

      it "can be specified a different refresh url" do
        refresh_url = "http://www.where-am-i.com/now"

        PageRefreshStrategy.new(url: refresh_url).to_html.should == "<meta http-equiv=\"refresh\" content=\"3; url=#{refresh_url}\" />"
      end

      [:new, :none].each do |kind|
        it "#{kind} should be html safe" do
          PageRefreshStrategy.send(kind).to_html.should be_html_safe
        end
      end

      it "handles ==" do
        PageRefreshStrategy.new.should == PageRefreshStrategy.new
        PageRefreshStrategy.new.should_not == PageRefreshStrategy.new(url: "http://www.google.com")
        PageRefreshStrategy.new.should_not == PageRefreshStrategy.new(url: "http://www.google.com")
        PageRefreshStrategy.new.should_not == PageRefreshStrategy.none

        PageRefreshStrategy.none.should == PageRefreshStrategy.none
        PageRefreshStrategy.none.should_not == PageRefreshStrategy.new
      end
    end
  end
end
