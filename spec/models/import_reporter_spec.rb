# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/monitoring_mailer_shared_examples'

shared_examples_for "Any ImportReporter" do

  before :each do
    @mailer_class = ImportReporter
    @mailer_template = :delta
    @total_duration = 7341
    @mailer_default_parameters = [@total_duration]
    ModelStat.stub(:generate_delta).and_return(@stats)
  end

  it_should_behave_like "Any MonitoringMailer"

  it "should have a subject with item count delta" do
    send_monitoring_email

    @subject.should include(@stats["Item"]['% delta'])
  end

  it "should have a subject containing \"OK\" for deltas smaller than 5%" do
    @stats["Item"] = {:old_count => 100, :count => 99, :delta => 0.99, '% delta' => "-1.00%"}

    send_monitoring_email

    @subject.should include("OK")
    @subject.should_not include("WARNING")
  end

  it "should contain a line describing the delta of each record type" do
    send_monitoring_email

    ModelStat::ALL.each do |record_type|
      record_stats = @stats[record_type]
      @body.should include("#{record_type}: #{record_stats[:old_count]} -> #{record_stats[:count]} #{record_stats['% delta']}")
    end
  end

  it "should contain a line with the total import duration" do
    send_monitoring_email

    @body.should include(Time.at(@total_duration).strftime("Import took : %H:%M:%S"))
  end

  should_contain_the_logs

end

describe ImportReporter do

  context "during an incremental import" do
    before :each do
      @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 1, :count => 2, :delta => 2.0, '% delta' => "+100.00%"},
                 ModelStat::CATEGORY => {:old_count => 4, :count => 8, :delta => 2.0, '% delta' => "+100.00%"},
                 ModelStat::ITEM => {:old_count => 20, :count => 27, :delta => 1.35, '% delta' => "+35.00%"}}
    end

    it_should_behave_like "Any ImportReporter"

    it "should have a subjet containing \"WARNING\" for deltas greater than 5%" do
      send_monitoring_email

      @subject.should include("WARNING")
      @subject.should_not include("OK")
    end

  end

  context "during a first import" do
    before :each do
      @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 0, :count => 2, '% delta' => "+2"},
                 ModelStat::CATEGORY => {:old_count => 0, :count => 8, '% delta' => "+8"},
                 ModelStat::ITEM => {:old_count => 0, :count => 27, '% delta' => "+27"}}
    end

    it_should_behave_like "Any ImportReporter"
  end


end
