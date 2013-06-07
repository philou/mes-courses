# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module HtmlUtils
    describe PageRefreshStrategy do

      it "default to refresh every 3 seconds" do
        expect(PageRefreshStrategy.new.to_html).to include('<meta http-equiv="refresh" content="3" />')
      end

      it "can be nil and emits an empty refreshNow() js function" do
        expect(PageRefreshStrategy.none.to_html).to eq('<script language="javascript">function refreshNow() {}</script>')
      end

      context "with a different interval" do

        before :each do
          @interval = 5
          @refresh_strategy = PageRefreshStrategy.new(interval: @interval)
        end

        it "refreshes at different interval" do
          expect(@refresh_strategy.to_html).to include("<meta http-equiv=\"refresh\" content=\"#{@interval}\" />")
        end

        it "generates a refreshNow() js function" do
          expect(@refresh_strategy.to_html).to include('<script language="javascript">function refreshNow() { window.location.href = ""; }</script>')
        end
      end

      context "with a different url" do

        before :each do
          @refresh_url = "http://www.where-am-i.com/now"
          @refresh_strategy = PageRefreshStrategy.new(url: @refresh_url)
        end

        it "redirects to another page" do
          expect(@refresh_strategy.to_html).to include("<meta http-equiv=\"refresh\" content=\"3; url=#{@refresh_url}\" />")
        end

        it "generates a refreshNow() js function" do
          expect(@refresh_strategy.to_html).to include("<script language=\"javascript\">function refreshNow() { window.location.href = \"#{@refresh_url}\"; }</script>")
        end
      end

      [:new, :none].each do |kind|
        it "#{kind} should be html safe" do
          expect(PageRefreshStrategy.send(kind).to_html).to be_html_safe
        end
      end

      it "handles ==" do
        expect(PageRefreshStrategy.new).to eq(PageRefreshStrategy.new)
        expect(PageRefreshStrategy.new).not_to eq(PageRefreshStrategy.new(url: "http://www.google.com"))
        expect(PageRefreshStrategy.new).not_to eq(PageRefreshStrategy.new(url: "http://www.google.com"))
        expect(PageRefreshStrategy.new).not_to eq(PageRefreshStrategy.none)

        expect(PageRefreshStrategy.none).to eq(PageRefreshStrategy.none)
        expect(PageRefreshStrategy.none).not_to eq(PageRefreshStrategy.new)
      end
    end
  end
end
