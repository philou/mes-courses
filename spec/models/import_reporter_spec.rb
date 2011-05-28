# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ImportReporter do

  before(:each) do
    ENV['APP_NAME'] = "mes-courses-tests"

    @stats = { ModelStat::ROOT_CATEGORY => {:old_count => 1, :count => 2, :delta => 2.0},
               ModelStat::CATEGORY => {:old_count => 4, :count => 8, :delta => 2.0},
               ModelStat::ITEM => {:old_count => 20, :count => 27, :delta => 1.35, '% delta' => "+35.00%"},}
  end

  def send_report_email
    @emails = ActionMailer::Base.deliveries
    @emails.clear()
    ModelStat.stub(:generate_delta).and_return(@stats)

    ImportReporter.deliver_delta

    @email = @emails.last
    @subject = @email.subject
    @body = eval(@email.body)
  end

  it "should send an email with the report" do
    send_report_email

    @emails.should have(1).entry
    @email.to.should_not be_empty
  end

  it "subject should contain the count when launched for first time" do
    @stats.each { |model, stat| stat[:old_count] = 0 }

    send_report_email

    @subject.should include(@stats["Item"][:count].to_s)
  end

  it "subjet should be descriptive" do
    send_report_email

    @subject.should include(ENV['APP_NAME'])
    @subject.should include(@stats["Item"]['% delta'])
  end

  it "subjet should contain \"WARNING\" for deltas greater than 5%" do
    send_report_email

    @subject.should include("WARNING")
    @subject.should_not include("OK")
  end

  it "subjet should contain \"OK\" for deltas smaller than 5%" do
    @stats["Item"] = {:old_count => 100, :count => 99, :delta => 0.99, '% delta' => "-1.00%"}

    send_report_email

    @subject.should include("OK")
    @subject.should_not include("WARNING")
  end

  it "should contain stats as string" do
    send_report_email

    eval(@email.body).should == @stats
  end

end
