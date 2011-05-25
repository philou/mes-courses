# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ImportReporter do

  UPDATE_DATE = Time.new
  PREVIOUS_DATE = UPDATE_DATE - 1.day
  STATS = { 'Root item category' => {'previous count' => 1, 'updated count' => 2},
              'Item category' => {'previous count' => 4, 'updated count' => 8},
              'Item' => {'previous count' => 20, 'updated count' => 27},}

  before(:each) do
    Item.stub(:count).and_return(STATS['Item']['updated count'])
    ItemCategory.stub(:count).and_return(STATS['Root item category']['updated count'], STATS['Item category']['updated count'])

    previous_stats = STATS.map do |model, stat|
      ModelStat.new(:name => model, :count => stat['previous count'])
    end
    ModelStat.stub(:find).and_return(previous_stats)
    ModelStat.stub(:create_or_update_by_name!)
    ModelStat.stub(:maximum).and_return(PREVIOUS_DATE, UPDATE_DATE)

    ENV['APP_NAME'] = "mes-courses-tests"

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  it "should save item stats before importing" do
    ModelStat.should_receive(:create_or_update_by_name!).with("Root item category", :count => STATS['Root item category']['updated count'])
    ModelStat.should_receive(:create_or_update_by_name!).with("Item category", :count => STATS['Item category']['updated count'])
    ModelStat.should_receive(:create_or_update_by_name!).with("Item", :count => STATS['Item']['updated count'])

    ImportReporter.update_stats_and_report
  end

  it "should send an email with the report" do
    ImportReporter.update_stats_and_report

    @emails.should have(1).entry
    @emails[0].to.should_not be_empty
  end

  context "generated report" do
    before(:each) do
      ImportReporter.update_stats_and_report
      @email = @emails[0]
      @subject = @email.subject
      @body = eval(@email.body)
    end

    it "subjet should be descriptive" do
      @subject.should include(ENV['APP_NAME'])
      @subject.should include(PREVIOUS_DATE.to_s)
      @subject.should include(UPDATE_DATE.to_s)
    end

    it "should contain stats for models" do
      @body.keys.should include_all(["Item", "Item category", "Root item category"])
    end

    it "should report past stats" do
      @body.each do |model, stats|
        stats['previous count'].should == STATS[model]['previous count']
      end
    end

    it "should report updated stats" do
      @body.each do |model, stats|
        stats['updated count'].should == STATS[model]['updated count']
      end
    end

    it "should report delta stats" do
      @body.each do |model, stats|
        stats['delta'].should == STATS[model]['updated count'].to_f / STATS[model]['previous count'].to_f
      end
    end
  end
end
