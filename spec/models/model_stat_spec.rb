# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe ModelStat do

  ROOT_COUNT = 2 # root and disabled
  CATEGORY_COUNT = 4
  ITEM_COUNT = 20

  before(:each) do
    # root categories
    ItemCategory.root
    ItemCategory.disabled

    @a_category = create_category
    ITEM_COUNT.times { create_item }

    while ItemCategory.count < CATEGORY_COUNT
      create_category
    end
  end

  def create_category
    FactoryGirl.create(:item_category, parent: ItemCategory.root)
  end
  def create_item
    FactoryGirl.create(:item, item_categories: [@a_category])
  end

  it "should snapshot current counts when updating" do
    ModelStat.update!

    expect(ModelStat.find_by_name(ModelStat::ITEM).count).to eq(ITEM_COUNT)
    expect(ModelStat.find_by_name(ModelStat::CATEGORY).count).to eq(CATEGORY_COUNT)
    expect(ModelStat.find_by_name(ModelStat::ROOT_CATEGORY).count).to eq(ROOT_COUNT)
  end

  it "should generate the expected delta from curent count versus saved model stats" do
    ModelStat.update!

    (ITEM_DELTA = 7).times { create_item }
    (CATEGORY_DELTA = 4).times { create_category }

    stats = ModelStat.generate_delta
    expect(stats[ModelStat::ROOT_CATEGORY]).to eq(old_count: ROOT_COUNT, count: ROOT_COUNT, delta: 1.0)
    expect(stats[ModelStat::CATEGORY]).to eq(old_count: CATEGORY_COUNT, count: CATEGORY_COUNT + CATEGORY_DELTA, delta: (CATEGORY_COUNT + CATEGORY_DELTA).to_f / CATEGORY_COUNT)
    expect(stats[ModelStat::ITEM]).to eq(old_count: ITEM_COUNT, count: ITEM_COUNT + ITEM_DELTA, delta: (ITEM_COUNT + ITEM_DELTA).to_f / ITEM_COUNT)
  end

  it "should generate delta without previous stats should have old_count == 0" do
    ModelStat.generate_delta.each do |name, stats|
      expect(stats[:old_count]).to eq 0
      expect(stats[:delta]).to be_nil
    end
  end

end
