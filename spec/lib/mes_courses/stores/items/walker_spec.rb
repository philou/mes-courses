# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

require "spec_helper"

module MesCourses
  module Stores
    module Items

      describe Walker do

        before :each do
          @page = double("Page", :uri => "http://www.maxi-discount.com")
          @page_getter = double("Getter", :get => @page, :text => "Conserves")
          @walker = Walker.new(@page_getter)

          @sub_walkers = [double("Sub walker")]
          @digger = double(Digger)
          @digger.stub(:sub_walkers).with(@page, @walker).and_return(@sub_walkers)
        end

        it "has the uri of its page" do
          @walker.uri.should == @page.uri
        end

        it "it uses the text of its origin (ex: link) as title" do
          @walker.title.should == @page_getter.text
        end

        context "by default" do
          it "has no items" do
            @walker.items.should be_empty
          end
          it "has no sub categories" do
            @walker.categories.should be_empty
          end
          it "has no attributes" do
            @walker.attributes.should be_empty
          end
        end

        it "uses its items digger to collect its items" do
          @walker.items_digger = @digger

          @walker.items.should == @sub_walkers
        end
        it "uses its categories digger to collect its sub categories" do
          @walker.categories_digger = @digger

          @walker.categories.should == @sub_walkers
        end
        it "uses its scrap attributes block to collect its attributes" do
          attributes = { :name => "Candy" }
          @walker.scrap_attributes_block = lambda { |page| attributes }

          @walker.attributes.should == attributes
        end

        context "when troubleshooting" do

          it "has a meaningfull string representation" do
            walker = Walker.new(@page_getter)
            walker.index= 23
            walker.to_s.should include(Walker.to_s)
            walker.to_s.should include("##{walker.index}")
            walker.to_s.should include("@#{walker.uri}")
          end
          it "has a full genealogy" do
            link = double("Link")
            link.stub_chain(:get, :uri).and_return(@page.uri + "/viandes")
            child_walker = Walker.new(link)
            child_walker.index = 12
            child_walker.father = @walker

            genealogy = child_walker.genealogy.split("\n")

            genealogy.should == [@walker.to_s, child_walker.to_s]
          end
        end
      end
    end
  end
end
