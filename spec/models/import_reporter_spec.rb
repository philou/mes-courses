# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ImportReporter do

  before(:each) do
    ENV['APP_NAME'] = "mes-courses-tests"

    @update_date = Time.new
    @previous_date = @update_date - 1.day
    @stats = { 'Root item category' => {'previous count' => 1, 'updated count' => 2, 'delta' => 2.0},
               'Item category' => {'previous count' => 4, 'updated count' => 8, 'delta' => 2.0},
               'Item' => {'previous count' => 20, 'updated count' => 27, 'delta' => 1.35, '% delta' => "+35.00%"},}

    set_up_stubs
  end

  def set_up_stubs
    Item.stub(:count).and_return(@stats['Item']['updated count'])
    ItemCategory.stub(:count).and_return(@stats['Root item category']['updated count'], @stats['Item category']['updated count'])

    previous_stats = @stats.map do |model, stat|
      ModelStat.new(:name => model, :count => stat['previous count'])
    end
    ModelStat.stub(:find).and_return(previous_stats)
    ModelStat.stub(:create_or_update_by_name!)
    ModelStat.stub(:maximum).and_return(@previous_date, @update_date)

    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end

  it "should save item stats before importing" do
    ModelStat.should_receive(:create_or_update_by_name!).with("Root item category", :count => @stats['Root item category']['updated count'])
    ModelStat.should_receive(:create_or_update_by_name!).with("Item category", :count => @stats['Item category']['updated count'])
    ModelStat.should_receive(:create_or_update_by_name!).with("Item", :count => @stats['Item']['updated count'])

    ImportReporter.update_stats_and_report
  end

  it "should send an email with the report" do
    ImportReporter.update_stats_and_report

    @emails.should have(1).entry
    @emails[0].to.should_not be_empty
  end

  context "generated report" do
    before(:each) do
      update_stats
    end

    def update_stats
      ImportReporter.update_stats_and_report
      @email = @emails[0]
      @subject = @email.subject
      @body = eval(@email.body)
    end

    it "subject should contain the updated count when launched for first time" do
      @stats.each do |model, stat|
        stat['previous count'] = 0
      end
      set_up_stubs
      update_stats

      @subject.should include(@stats["Item"]["updated count"].to_s)
    end

    it "subjet should be descriptive" do
      @subject.should include(ENV['APP_NAME'])
      @subject.should include(@stats["Item"]['% delta'])
    end

    it "subjet should contain \"WARNING\" for deltas greater than 5%" do
      @subject.should include("WARNING")
      @subject.should_not include("OK")
    end

    it "subjet should contain \"OK\" for deltas smaller than 5%" do
      @stats["Item"] = {'previous count' => 100, 'updated count' => 99, 'delta' => 0.99, '% delta' => "-1.00%"}
      set_up_stubs
      update_stats

      @subject.should include("OK")
      @subject.should_not include("WARNING")
    end

    it "should contain stats for models" do
      @body.keys.should include_all(["Item", "Item category", "Root item category"])
    end

    it "should report past stats" do
      @body.each do |model, stats|
        stats['previous count'].should == @stats[model]['previous count']
      end
    end

    it "should report updated stats" do
      @body.each do |model, stats|
        stats['updated count'].should == @stats[model]['updated count']
      end
    end

    it "should report delta stats" do
      @body.each do |model, stats|
        stats['delta'].should == @stats[model]['delta']
      end
    end
  end

end
