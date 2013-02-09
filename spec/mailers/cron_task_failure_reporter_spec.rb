# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require 'lib/mes_courses/rails_utils/monitoring_mailer_base_shared_examples'

describe CronTaskFailureReporter do
  include MesCourses::RailsUtils::MonitoringMailerBaseSpecMacros

  before :each do
    @mailer_class = CronTaskFailureReporter
    @mailer_template = :failure
    @mailer_default_parameters = [@task_name = "test_all", @exception = NotImplementedError.new("niark niark niarlk")]
    @exception.stub(:backtrace).and_return([])
  end

  it_should_behave_like_any_monitoring_mailer

  it "'s subject should contain an error marker" do
    send_monitoring_email

    @subject.should include("ERROR")
  end
  it "'s subject should contain the failed task name" do
    send_monitoring_email

    @subject.should include(@task_name)
  end
  it "'s subject should contain the class name of the exception" do
    send_monitoring_email

    @subject.should include(@exception.class.name)
  end
  it "'s subject should contain the message of the exception" do
    send_monitoring_email

    @subject.should include(@exception.message)
  end

  should_contain_the_logs

  it "'s body should contain the exception trace" do
    @exception.stub(:backtrace).and_return(["very long and complicated stack trace","frame 1","frame 2"])

    send_monitoring_email

    @body.should include (@exception.backtrace.join("\n"))
  end

end
