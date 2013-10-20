# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require_relative 'api_builder'

module MesCourses
  module Stores
    module Items

      module AuchanDirectApi
        NAMES_SEPARATOR = ', '
      end

      define_api "auchandirect.fr" do

        categories '#footer-menu h2 a' do
          attributes do
            { name: page.get_one('#content .titre-principal').content }
          end

          categories '#content .menu-listes h2 a' do
            attributes do
              { name: page.get_one('#content .titre-principal').content }
            end

            categories '#content .bloc_prd > a' do
              attributes do
                { :name => page.get_one("#wrap-liste-produits-nav .titre-principal").content }
              end

              items '.infos-produit-2 > a' do
                attributes do
                  {
                    :brand => page.get_one('#produit-infos .titre-principal').content,
                    :name => page.get_all('#produit-infos .titre-annexe, #produit-infos .titre-secondaire', AuchanDirectApi::NAMES_SEPARATOR),
                    :price => page.get_one('#produit-infos .prix-actuel > span, #produit-infos .bloc-prix-promo > span.prix-promo').content.to_f,
                    :image => page.get_image('#produit-infos img.produit').url.to_s,
                    :remote_id => /\/([^\/\.]*)[^\/]*$/.match(uri.to_s)[1]
                  }
                end
              end
            end
          end
        end
      end
    end
  end
end
