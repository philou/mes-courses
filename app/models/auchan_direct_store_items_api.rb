# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'store_items_api_builder'

define_store_items_api :auchan_direct_store_items_api do

  categories '#carroussel > div a' do
    attributes do
      { :name => get_one(page, "#bandeau_label_recherche").content }
    end

    categories '#blocCentral > div a' do
      attributes do
        { :name => get_one(page, "#bandeau_label_recherche").content }
      end

      items '#blocs_articles a.lienArticle' do
        attributes do
          product_type = get_one(page, '.typeProduit')
          product_infos = get_one(page, '#infosProduit')

          remote_id = /article\/(\d+)(\.html)?$/.match(uri.to_s)[1].to_i

          {
            :name => get_one_css(page, product_type, '.nomRayon').content,
            :summary => get_one_css(page, product_type, '.nomProduit').content,
            :price => get_one_css(page, product_infos, '.prixQteVal1').content.to_f,
            :image => get_one_css(page, product_infos, '#imgProdDetail')['src'],
            :remote_id => remote_id
          }
        end
      end
    end
  end
end
