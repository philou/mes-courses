# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ModelStat do

  context "create_or_update_by_name!" do

    MODEL_NAME = "A model name"

    before(:each) do
      ModelStat.stub(:find_or_initialize_by_name).and_return(ModelStat.new(:name => MODEL_NAME))
    end

    it "should search an existing record before creating a new one" do
      ModelStat.should_receive(:find_or_initialize_by_name).with(MODEL_NAME)
      ModelStat.create_or_update_by_name!(MODEL_NAME, :count => 0)
    end

    it "should return a saved record" do
      stat = ModelStat.create_or_update_by_name!(MODEL_NAME, :count => 0)
      stat.should_not be_new_record
    end

    it "should return an updated record" do
      stat = ModelStat.create_or_update_by_name!(MODEL_NAME, :count => 5)
      stat.count.should == 5
    end
  end
end
