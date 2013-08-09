# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

require "spec_helper"

module MesCourses
  module Stores
    module Items

      describe Digger do

        before :each do
          @digger = Digger.new(@selector = "a.items", @factory = double("Sub walker factory"))
          @page = double(WalkerPage)
          @page.stub(:search_links).with(@selector).and_return(@links = [double("Link"),double("Link")])
        end

        it "creates sub walkers for each link it finds" do
          @links.each do |link|
            expect(@factory).to receive(:new).with(link, anything, anything)
          end

          @digger.sub_walkers(@page, nil).to_a
        end

        it "for debugging purpose, provides father walker and link index to sub walkers" do
          father = double("Father walker")

          @links.each_with_index do |link, index|
            expect(@factory).to receive(:new).with(link, father, index)
          end

          @digger.sub_walkers(@page, father).to_a
        end

      end
    end
  end
end
