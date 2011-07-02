# Copyright (C) 2011 by Philippe Bourgau

class DummyStoreItemsAPI
  def initialize(attributes)
    default_values = {
      :items => [],
      :categories => [],
      :uri => DummyStoreItemsAPI.unique_uri,
      :remote_id => DummyStoreItemsAPI.unique_remote_id,
      :image => DummyStoreItemsAPI.unique_image
    }
    values = default_values.merge(attributes)

    @uri = URI.parse(values[:uri])
    @attributes = values.reject{ |k,v| [:items, :uri, :categories].include?(k) }
    @items = DummyStoreItemsAPI.news(values[:items])
    @categories = DummyStoreItemsAPI.news(values[:categories])
  end

  def self.new_custom_store(root_categories)
    new(:uri => DummyStoreCartAPI.url,
        :categories => root_categories)
  end

  def self.new_complete_store(uri = DummyStoreCartAPI.url)
    new(:uri => uri,
        :categories => [{ :name => "Produits laitiers",
                          :categories => [{ :name => "Lait",
                                            :items => [{ :name => "Lait enier", :summary => "Lait entier", :price => 0.67 }]},
                                          { :name => "Fromages",
                                            :items => [{ :name => "Camembert", :summary => "De Normandie", :price => 3.2 }]}]},
                        { :name => "Surgelés",
                          :categories => [{ :name => "Plats préparés",
                                            :items => [{ :name => "Pizzas anchois champignons tomates mozarella olives", :summary => "Prête en 5 minutes", :price => 4.5 },
                                                       { :name => "Tomates farcies", :summary => "Viande francaise", :price => 3 }]},
                                          { :name => "Légumes",
                                            :items => [{ :name => "haricots verts", :summary => "extra fins", :price => 2.09 },
                                                       { :name => "carottes", :summary => "en rondelles", :price => 3.2}]}]},
                        { :name => "Utilitaires"}])
  end

  attr_reader :uri, :attributes, :items, :categories

  def link_text
    attributes[:name]
  end

  private

  def self.unique_remote_id
    @remote_id_counter ||= 0
    @remote_id_counter += 1
  end

  def self.unique_uri
    @uri_counter ||= 0
    "#{DummyStoreCartAPI.url}/article/#{@uri_counter += 1}"
  end

  def self.unique_image
    @image_counter ||= 0
    "#{DummyStoreCartAPI.url}/images/#{@image_counter += 1}"
  end

  def self.news(attributes_array)
    attributes_array.map { |attributes| new(attributes) }
  end

end

