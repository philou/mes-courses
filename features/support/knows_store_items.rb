# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module KnowsStoreItems

  def generate_store(store_name, item_table = :no_extra_items)
    store = Storexplore::Testing::DummyStore.open(store_name)
    store.generate(3).categories.and(3).categories.and(3).items

    unless item_table == :no_extra_items
      add_items_to_generated_store(store_name, item_table)
    end

    create_new_store(store.uri)
  end

  def import_real_dummy_store(store_name)
    Store.find_by_url(Storexplore::Testing::DummyStore.uri(store_name)).import
  end

  def add_items_to_generated_store(store_name, item_table)
    store = Storexplore::Testing::DummyStore.open(store_name)

    item_table.each_item do |category, sub_category, item, explicit_attributes|
      store.category(category).category(sub_category).item(item).generate().attributes(explicit_attributes)
    end
  end

  def remove_items_from_generated_store(store_name, item_table)
    store = Storexplore::Testing::DummyStore.open(store_name)

    item_table.each_item do |category, sub_category, item|
      store.category(category).category(sub_category).remove_item(item)
    end
  end

  def raise_prices_in_generated_store(store_name)
    store = Storexplore::Testing::DummyStore.open(store_name)
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
    items_count(Storexplore::Testing::DummyStore.open(store_name))
  end

  def simulate_network_issues(&raise_predicate)
    speed_up_store_import_retrier
    raise_network_error_when &raise_predicate
  end

  def fix_network_issues
    Mechanize::Page.unstub(:new)
  end

  private

  def items_count(category)
    category.categories.map {|cat| items_count(cat)}.inject(0) {|a,b| a+b } +
      category.items.count
  end

  def speed_up_store_import_retrier
    new_import_retrier_options = Store.import_retrier_options.merge(:sleep_delay => 0)
    Store.stub(:import_retrier_options).and_return(new_import_retrier_options)
  end

  def raise_network_error_when
    i = 0
    Mechanize::Page.on_call_to(:new) do
      i = i+1
      raise RuntimeError.new("network down") if yield(i)
    end
  end

end
World(KnowsStoreItems)
