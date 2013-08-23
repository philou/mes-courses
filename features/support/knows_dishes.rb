# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsDishes

  def create_dishes(table)
    table.hash_2_lists.each do |name, items_names|
      items = items_names.map do |item_name|
        FactoryGirl.create(:item_with_categories, name: item_name)
      end

      FactoryGirl.create(:dish, name: name, items: items)
    end
  end

end
World(KnowsDishes)
