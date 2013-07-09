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
          enumerator_of_cat_sub_cat_and_items_tokens.

          map do |tokens|
            promo_price(*tokens)
          end.

          select do |price|
            !price.nil?
          end.

          first.should be_instance_of(Float)
        end

        private

        def enumerator_of_cat_sub_cat_and_items_tokens
          `find #{File.join(Rails.root,'offline_sites','www.auchandirect.fr')} -name *.html -exec grep -l "prix-promo" {} \\;`.split("\n").lazy.

          select do |file|
            doc = Nokogiri::HTML(open(file))
            doc.search("#produit-infos .bloc-prix-promo > span.prix-promo").any?
          end.

          map do |file|
            file = URI.unescape(file)
            file = file.gsub(/^.*\/www\.auchandirect\.fr\//, "")
            pieces = file.split("/").take(3)
            pieces[2] = pieces[2].split(",")[0]
            pieces = pieces.map do |piece|
              piece.gsub(/lv_/,'').split(/[\-_, \(\)']+/).select {|p| not (p.size <= 2 or p =~ /^[0-9]/)}
            end

            pieces
          end
        end

        def promo_price(cat_tokens, sub_cat_tokens, item_tokens)
          filter(@store.categories, cat_tokens).each do |cat|
            filter(cat.categories, sub_cat_tokens).each do |sub_cat|
              sub_cat.categories.each do |sub_sub_cat|
                filter(sub_sub_cat.items, item_tokens).each do |item|
                  return item.attributes[:price]
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
