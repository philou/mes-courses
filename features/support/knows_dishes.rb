# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsDishes

  def create_dishes(table)
    table.hash_2_lists.each do |name, items_long_names|
      items = items_long_names.map do |item_long_name|
        FactoryGirl.create(:item_with_categories, parse_attributes(item_long_name))
      end

      FactoryGirl.create(:dish, name: name, items: items)
    end
  end

  private

  BRAND_AND_NAME = /([A-Z ]+,)? ?(.*)/

  def parse_attributes(item_long_name)
    brand, name = BRAND_AND_NAME.match(item_long_name)[1..2]

    result = {name: name}
    result[:brand] = brand unless brand.nil?

    result
  end

end
World(KnowsDishes)
