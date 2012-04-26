# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe CronTaskFailureReporter do
  include MonitoringMailerSpecMacros

  before :each do
    @mailer_class = CronTaskFailureReporter
    @mailer_template = :failure
    @mailer_default_parameters = [@task_name = "test_all", @exception = stub(Exception, :backtrace => [])]
  end

  it_should_behave_like_any_monitoring_mailer

  it "'s subject should contain the failed task name" do
    send_monitoring_email

    @subject.should include("ERROR cron task '#{@task_name}' failed")
  end

  should_contain_the_logs

  it "'s body should contain the exception trace" do
    @exception.stub(:backtrace).and_return(["very long and complicated stack trace","frame 1","frame 2"])

    send_monitoring_email

    @body.should include (@exception.backtrace.join("\n"))
  end

end
