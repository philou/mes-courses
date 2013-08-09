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
          expect(@walker.uri).to eq @page.uri
        end

        it "it uses the text of its origin (ex: link) as title" do
          expect(@walker.title).to eq @page_getter.text
        end

        context "by default" do
          it "has no items" do
            expect(@walker.items).to be_empty
          end
          it "has no sub categories" do
            expect(@walker.categories).to be_empty
          end
          it "has no attributes" do
            expect(@walker.attributes).to be_empty
          end
        end

        it "uses its items digger to collect its items" do
          @walker.items_digger = @digger

          expect(@walker.items).to eq @sub_walkers
        end
        it "uses its categories digger to collect its sub categories" do
          @walker.categories_digger = @digger

          expect(@walker.categories).to eq @sub_walkers
        end
        it "uses its scrap attributes block to collect its attributes" do
          attributes = { :name => "Candy" }
          @walker.scrap_attributes_block = lambda { |page| attributes }

          expect(@walker.attributes).to eq attributes
        end

        context "when troubleshooting" do

          it "has a meaningfull string representation" do
            walker = Walker.new(@page_getter)
            walker.index= 23
            expect(walker.to_s).to include(Walker.to_s)
            expect(walker.to_s).to include("##{walker.index}")
            expect(walker.to_s).to include("@#{walker.uri}")
          end
          it "has a full genealogy" do
            link = double("Link")
            link.stub_chain(:get, :uri).and_return(@page.uri + "/viandes")
            child_walker = Walker.new(link)
            child_walker.index = 12
            child_walker.father = @walker

            genealogy = child_walker.genealogy.split("\n")

            expect(genealogy).to eq [@walker.to_s, child_walker.to_s]
          end
        end
      end
    end
  end
end
