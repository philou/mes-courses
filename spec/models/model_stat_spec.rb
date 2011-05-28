# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ModelStat do

  before(:each) do
    @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 1, :count => 2, :delta => 2.0},
               ModelStat::CATEGORY => {:old_count => 4, :count => 8, :delta => 2.0},
               ModelStat::ITEM => {:old_count => 20, :count => 27, :delta => 1.35}}

    Item.stub(:count).        and_return(@stats[ModelStat::ITEM][:count])
    ItemCategory.stub(:count).and_return(@stats[ModelStat::ROOT_CATEGORY][:count],
                                         @stats[ModelStat::CATEGORY][:count])
  end

  it "should save item stats when updating" do
    ModelStat::ALL.each do |name|
      stat = ModelStat.new(:name => name)
      ModelStat.should_receive(:find_or_initialize_by_name).with(name).and_return(stat)
      stat.should_receive(:update_attributes!).with(:count => @stats[name][:count])
    end

    ModelStat.update!
  end

  it "should generate the expected delta" do
    old_stats = @stats.map do |model, stat|
      ModelStat.new(:name => model, :count => stat[:old_count])
    end
    ModelStat.stub(:find).and_return(old_stats)

    ModelStat.generate_delta.should == @stats
  end

  it "should generate delta without previous stats should have old_count == 0" do
    ModelStat.stub(:find).and_return([])

    ModelStat.generate_delta.each do |name, stats|
      stats[:old_count].should == 0
    end
  end

end
