# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe ModelStat do

  before(:each) do
    # root categories
    ItemCategory.root
    ItemCategory.disabled
    @root_count = 2

    @a_category = create_category
    20.times { create_item }
    @item_count = Item.count

    while ItemCategory.count < 4
      create_category
    end
    @category_count = ItemCategory.count

  end

  def create_category
    FactoryGirl.create(:item_category, parent: ItemCategory.root)
  end
  def create_item
    FactoryGirl.create(:item, item_categories: [@a_category])
  end

  it "should snapshot current counts when updating" do
    ModelStat.update!

    expect(ModelStat.find_by_name(ModelStat::ITEM).count).to eq(@item_count)
    expect(ModelStat.find_by_name(ModelStat::CATEGORY).count).to eq(@category_count)
    expect(ModelStat.find_by_name(ModelStat::ROOT_CATEGORY).count).to eq(@root_count)
  end

  it "should generate the expected delta from curent count versus saved model stats" do
    ModelStat.update!

    (item_delta = 7).times { create_item }
    (category_delta = 4).times { create_category }

    stats = ModelStat.generate_delta
    expect(stats[ModelStat::ROOT_CATEGORY]).to eq(old_count: @root_count, count: @root_count, delta: 1.0)
    expect(stats[ModelStat::CATEGORY]).to eq(old_count: @category_count, count: @category_count + category_delta, delta: (@category_count + category_delta).to_f / @category_count)
    expect(stats[ModelStat::ITEM]).to eq(old_count: @item_count, count: @item_count + item_delta, delta: (@item_count + item_delta).to_f / @item_count)
  end

  it "should generate delta without previous stats should have old_count == 0" do
    ModelStat.generate_delta.each do |name, stats|
      expect(stats[:old_count]).to eq 0
      expect(stats[:delta]).to be_nil
    end
  end

end
