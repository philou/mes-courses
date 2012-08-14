# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'mes_courses/store_carts/dummy_store_cart_api'

class DummyStoreItemsAPI
  def self.new_custom_store(root_categories)
    new(completed_config(:categories => root_categories))
  end

  def self.new_default_store(uri = MesCourses::StoreCarts::DummyStoreCartAPI.url)
    new(full_config(uri))
  end

  def self.full_config(uri = MesCourses::StoreCarts::DummyStoreCartAPI.url)
    completed_config( :uri => uri,
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
                      )
  end

  def self.shrinked_config(width, config = DummyStoreItemsAPI.full_config)
    clone_with(config, [:items, :categories]) { |items| items[0..(width-1)] }
  end

  def initialize(attributes)
    @uri = attributes[:uri]
    @attributes = attributes[:attributes]
    @categories = DummyStoreItemsAPI.news(attributes[:categories])
    @items = DummyStoreItemsAPI.news(attributes[:items])
  end

  attr_reader :uri, :attributes, :items, :categories

  def title
    attributes[:name]
  end

  def total_items_count
    categories.inject(0) { |sum, cat| sum + cat.total_items_count } + items.count
  end

  private

  def self.clone_with(config, keys, &transform)
    if config.instance_of?(Hash)
      result = { }
      config.each do |k, v|
        if keys.include? k
          v = transform.call(v)
        end
        result[k] = clone_with(v, keys, &transform)
      end
      result
    elsif config.instance_of?(Array)
      config.map{ |sub_config| clone_with(sub_config, keys, &transform) }
    else
      config
    end
  end

  def self.completed_config(config)
    config = { :uri => MesCourses::StoreCarts::DummyStoreCartAPI.url }.merge(config)
    remote_id = 0
    completed_config_ex(config, config[:uri], false) { remote_id += 1 }
  end
  def self.completed_config_ex(config, base_uri, is_item, &new_remote_id)
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
    config = default_values.merge(config)

    { :uri => URI.parse(config[:uri]),
      :attributes => config.reject{ |k,v| [:items, :uri, :categories].include?(k) },
      :categories => config[:categories].map { |category_config| completed_config_ex(category_config, base_uri, false, &new_remote_id) },
      :items => config[:items].map { |item_config| completed_config_ex(item_config, base_uri, true, &new_remote_id) }
    }
  end

  def self.news(attributes_array)
    attributes_array.map do |attributes|
      DummyStoreItemsAPI.new(attributes)
    end
  end

end

