# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'store_items_api_builder'

define_store_items_api :auchan_direct_store_items_api do

  categories '#carroussel > div a' do
    attributes do
      { :name => page.get_one("#bandeau_label_recherche").content }
    end

    categories '#blocCentral > div a' do
      attributes do
        { :name => page.get_one("#bandeau_label_recherche").content }
      end

      items '#blocs_articles a.lienArticle' do
        attributes do
          {
            :name => page.get_one('.typeProduit .nomRayon').content,
            :summary => page.get_one('.typeProduit .nomProduit').content,
            :price => page.get_one('#infosProduit .prixQteVal1').content.to_f,
            :image => page.get_one('#infosProduit #imgProdDetail')['src'],
            :remote_id => /article\/(\d+)(\.html)?$/.match(uri.to_s)[1].to_i
          }
        end
      end
    end
  end
end
