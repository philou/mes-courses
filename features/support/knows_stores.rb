# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsStores

  def generate_store(store_name, item_table = :no_extra_items)
    store = MesCourses::Stores::Items::RealDummy.open(store_name)
    store.generate(3).categories.and(3).categories.and(3).items

    unless item_table == :no_extra_items
      add_items_to_generated_store(store_name, item_table)
    end

    Store.create(url: store.uri, sponsored_url: store.uri)
  end

  def import_real_dummy_store(store_name)
    Store.find_by_url(MesCourses::Stores::Items::RealDummy.uri(store_name)).import
  end

  def add_items_to_generated_store(store_name, item_table)
    store = MesCourses::Stores::Items::RealDummy.open(store_name)

    item_table.each_item do |category, sub_category, item, explicit_attributes|
      store.category(category).category(sub_category).item(item).generate().attributes(explicit_attributes)
    end
  end

  def remove_items_from_generated_store(store_name, item_table)
    store = MesCourses::Stores::Items::RealDummy.open(store_name)

    item_table.each_item do |category, sub_category, item|
      store.category(category).category(sub_category).remove_item(item)
    end
  end

  def raise_prices_in_generated_store(store_name)
    store = MesCourses::Stores::Items::RealDummy.open(store_name)
    store.categories.each do |category|
      category.categories.each do |sub_category|
        sub_category.items.each do |item|
          price = item.attributes[:price].to_f
          item.attributes(price: (price + 0.5).to_s)
        end
      end
    end
  end

  def items_count_in_generated_store(store_name)
    items_count(MesCourses::Stores::Items::RealDummy.open(store_name))
  end

  def simulate_network_issues
    i = 0
    original_new = Mechanize::Page.method(:new)
    Mechanize::Page.stub(:new) do |*args, &block|
      i = i+1
      raise RuntimeError.new("network down") if yield(i)
      original_new.call(*args, &block)
    end
  end

  def fix_network_issues
    Mechanize::Page.unstub(:new)
  end

  private

  def items_count(category)
    category.categories.map {|cat| items_count(cat)}.inject(0) {|a,b| a+b } +
      category.items.count
  end

end
World(KnowsStores)
