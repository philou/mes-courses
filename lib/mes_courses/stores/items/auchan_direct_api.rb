# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require_relative 'api_builder'

module MesCourses
  module Stores
    module Items

      define_api "auchandirect.fr" do

        categories '#footer-menu a' do
          attributes do
            { :name => page.get_one("#wrap-liste-produits-nav .titre-principal").content }
          end

          items '.infos-produit-2 > a' do
            attributes do
              puts "uri : #{uri}"
              {
                :name => page.get_one('#produit-infos .titre-principal').content,
                :summary => page.get_one('#produit-infos .titre-annexe').content,
                :price => page.get_one('#produit-infos .prix-actuel > span',
                                       '#produit-infos .bloc-prix-promo > span.prix-promo').content.to_f,
                :image => page.get_image('#produit-infos img.produit').url.to_s,
                :remote_id => /\/(\d+)[^\/]*$/.match(uri.to_s)[1].to_i
              }
            end
          end
        end
      end
    end
  end
end
