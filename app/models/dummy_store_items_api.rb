# Copyright (C) 2011 by Philippe Bourgau

class DummyStoreItemsAPI
  def self.new_custom_store(root_categories)
    new(:uri => DummyStoreCartAPI.url,
        :categories => root_categories)
  end

  def self.new_complete_store(uri = DummyStoreCartAPI.url)
    new(complete_store_config(uri))
  end

  def self.complete_store_config(uri)
    config = { :uri => uri,
      :categories => [{ :name => "Produits frais",
                        :categories => [{ :name => "Légumes",
                                          :items => [{ :name => "Tomates", :summary => "Rondes", :price => 2.04 },
                                                     { :name => "Concombres", :summary => "Espagne", :price => 0.99 },
                                                     { :name => "Radis", :summary => "Botte de 30", :price => 1.99 }
                                                    ]
                                        },
                                        { :name => "Fruits",
                                          :items => [{ :name => "Pommes", :summary => "Golden", :price => 1.99 },
                                                     { :name => "Bananes", :summary => "Martinique", :price => 2.3 },
                                                     { :name => "Poires", :summary => "Conference", :price => 3.9 }
                                                    ]
                                        },
                                        { :name => "Poissons",
                                          :items => [{ :name => "Sardines", :summary => "Atlantique", :price => 2.4 },
                                                     { :name => "Filets de saumon", :summary => "400g", :price => 5.2 },
                                                     { :name => "Dos de cabillaud", :summary => "Atlantique x2", :price => 9.99 }
                                                    ]
                                        }
                                       ]
                      },
                      { :name => "Produits laitiers",
                        :categories => [{ :name => "Lait",
                                          :items => [{ :name => "Lait entier", :summary => "Lait entier", :price => 0.67 },
                                                     { :name => "Lait demi écrémé", :summary => "UHT", :price => 0.53 },
                                                     { :name => "Lait écrémé", :summary => "UHT", :price => 0.79 }
                                                    ]
                                        },
                                        { :name => "Fromages",
                                          :items => [{ :name => "Camembert", :summary => "De Normandie", :price => 3.2 },
                                                     { :name => "Feta", :summary => "De Grèce", :price => 2.6 },
                                                     { :name => "Saveur du Maquis", :summary => "Fromage de brebis Corse", :price => 5.3 }
                                                    ]
                                        },
                                        { :name => "Yaourts et desserts",
                                          :items => [{ :name => "Fromage blanc", :summary => "Bio", :price => 2.5 },
                                                     { :name => "Petit suisse", :summary => "x6", :price => 1.2 },
                                                     { :name => "Yaourt fruité", :summary => "x8", :price => 3.1 }
                                                    ]
                                        }
                                       ]
                      },
                      { :name => "Surgelés",
                        :categories => [{ :name => "Plats préparés",
                                          :items => [{ :name => "Pizzas royale", :summary => "Prête en 5 minutes", :price => 4.5 },
                                                     { :name => "Tomates farcies", :summary => "Viande francaise", :price => 3 },
                                                     { :name => "Coquilles St Jacques", :summary => "Préparation à la Bretonne", :price => 5.7 }
                                                    ]
                                        },
                                        { :name => "Légumes",
                                          :items => [{ :name => "haricots verts", :summary => "extra fins", :price => 2.09 },
                                                     { :name => "carottes", :summary => "en rondelles", :price => 3.2 },
                                                     { :name => "Purée de pomme de terre", :summary => "1kg", :price => 1.9 }
                                                    ]
                                        },
                                        { :name => "Desserts",
                                          :items => [{ :name => "Glaces à la vanille", :summary => "en pot", :price => 1.5 },
                                                     { :name => "Esquimaux", :summary => "Vanille-chocolat", :price => 2.6 },
                                                     { :name => "Napolitain glacé", :summary => "Plat familliale pour 6 personnes", :price => 3.2 }
                                                    ]
                                        }
                                       ]
                      }
                     ]
    }
    with_default_values(config, uri)
  end

  def self.with_default_values(config, base_uri)
    remote_id = 0
    with_default_values_ex(config, base_uri, false) { remote_id += 1 }
  end
  def self.with_default_values_ex(config, base_uri, is_item, &new_remote_id)
    remote_id = new_remote_id.call
    default_values = {
      :uri => "#{base_uri}/article/#{remote_id}",
      :categories => [],
      :items => []
    }
    if is_item
      default_values[:remote_id] = remote_id
      default_values[:image] = "#{base_uri}/images/#{remote_id}"
    end
    result = default_values.merge(config)
    result[:categories] = result[:categories].map { |category_config| with_default_values_ex(category_config, base_uri, false, &new_remote_id) }
    result[:items] = result[:items].map { |item_config| with_default_values_ex(item_config, base_uri, true, &new_remote_id) }

    result
  end

  attr_reader :uri, :attributes, :items, :categories

  def link_text
    attributes[:name]
  end

  private

  def initialize(attributes)
    default_values = {
      :items => [],
      :categories => [],
      :uri => DummyStoreItemsAPI.unique_uri,
    }
    values = default_values.merge(attributes)

    @uri = URI.parse(values[:uri])
    @attributes = values.reject{ |k,v| [:items, :uri, :categories].include?(k) }
    @categories = values[:categories].map do |attributes|
      DummyStoreItemsAPI.new(attributes)
    end
    @items = values[:items].map do |attributes|
      default_item_attributes = {
        :remote_id => DummyStoreItemsAPI.unique_remote_id,
        :image => DummyStoreItemsAPI.unique_image
      }
      DummyStoreItemsAPI.new(default_item_attributes.merge(attributes))
    end
  end

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

end

