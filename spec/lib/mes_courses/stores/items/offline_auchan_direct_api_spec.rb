# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

module MesCourses
  module Stores
    module Items
      describe "OfflineAuchanDirectApi", slow: true do
        include ApiSpecMacros

        before :all do
          auchan_direct_offline = "file://"+File.join(Rails.root,'offline_sites','www.auchandirect.fr', 'index.html')
          @store = Api.browse(auchan_direct_offline)
        end

        it_should_behave_like_any_store_items_api

        it "parses promotions prices" do
          prices = items_with('prix-promo', "#produit-infos .bloc-prix-promo > span.prix-promo").
            map {|item_info| item_info[:item].attributes[:price] }

          expect(prices.first).to be_instance_of(Float)
        end

        it "collects secondary titles" do
          item_infos = items_with('titre-secondaire', '#produit-infos .titre-secondaire').first

          expect(item_infos[:item].attributes[:name]).to include(AuchanDirectApi::NAMES_SEPARATOR + item_infos[:elements].first.text)
        end

        private

        def items_with(grep_hint, selector)
          search_through_files_for(grep_hint, selector).
            map {|item_info| add_corresponding_item_to(item_info)}.
            select {|item_info| !item_info.nil? }
        end

        def search_through_files_for(grep_hint, selector)
          `find #{File.join(Rails.root,'offline_sites','www.auchandirect.fr')} -name *.html -exec grep -l "#{grep_hint}" {} \\;`.split("\n").lazy.

          map do |file|
            doc = Nokogiri::HTML(open(file))
            [file, doc.search(selector)]
          end.

          select do |file, elements|
            !elements.empty?
          end.

          map do |file, elements|
            # example : http://www.auchandirect.fr/petit-dejeuner-epicerie-sucree/chocolats,-confiseries/barres-biscuitees-muesli---cereales/id1/485/53869

            file = URI.unescape(file)
            file = file.gsub(/^.*\/www\.auchandirect\.fr\//, "")
            pieces = file.split("/").take(3)
            pieces[2] = pieces[2].split(",")[0]
            pieces = pieces.map do |piece|
              piece.gsub(/lv_/,'').split(/[\-_, \(\)']+/).select {|p| not (p.size <= 2 or p =~ /^[0-9]/)}
            end

            {cat_tokens: pieces[0], sub_cat_tokens: pieces[1], item_tokens: pieces[2], elements: elements}
          end
        end


        def add_corresponding_item_to(item_info)
          filter(@store.categories, item_info[:cat_tokens]).each do |cat|
            filter(cat.categories, item_info[:sub_cat_tokens]).each do |sub_cat|
              sub_cat.categories.each do |sub_sub_cat|
                filter(sub_sub_cat.items, item_info[:item_tokens]).each do |item|
                  return item_info.merge(item: item)
                end
              end
            end
          end
          nil
        end

        def filter(sub_elements, tokens)
          sub_elements.select do |element|
            tokens.all? do |token|
              element.attributes[:name].downcase.include?(token.downcase)
            end
          end
        end
      end
    end
  end
end
