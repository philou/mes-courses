# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/monitoring_mailer_shared_examples'

describe ImportReporter do
  it_should_behave_like "Any MonitoringMailer"

  before(:each) do
    @mailer_class = ImportReporter
    @mailer_template = :delta
    @mailer_default_parameters = []

    @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 1, :count => 2, :delta => 2.0},
               ModelStat::CATEGORY => {:old_count => 4, :count => 8, :delta => 2.0},
               ModelStat::ITEM => {:old_count => 20, :count => 27, :delta => 1.35, '% delta' => "+35.00%"},}
    ModelStat.stub(:generate_delta).and_return(@stats)
  end

  it "should have a subject containing the count when launched for first time" do
    @stats.each { |model, stat| stat[:old_count] = 0 }

    send_monitoring_email

    @subject.should include(@stats["Item"][:count].to_s)
  end

  it "should have a subject with item count delta" do
    send_monitoring_email

    @subject.should include(@stats["Item"]['% delta'])
  end

  it "should have a subjet containing \"WARNING\" for deltas greater than 5%" do
    send_monitoring_email

    @subject.should include("WARNING")
    @subject.should_not include("OK")
  end

  it "should have a subject containing \"OK\" for deltas smaller than 5%" do
    @stats["Item"] = {:old_count => 100, :count => 99, :delta => 0.99, '% delta' => "-1.00%"}

    send_monitoring_email

    @subject.should include("OK")
    @subject.should_not include("WARNING")
  end

  it "should contain stats as string" do
    send_monitoring_email

    eval(@body).should == @stats
  end

end
