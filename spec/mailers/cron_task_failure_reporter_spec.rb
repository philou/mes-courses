# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


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

    expect(@subject).to include("ERROR")
  end
  it "'s subject should contain the failed task name" do
    send_monitoring_email

    expect(@subject).to include(@task_name)
  end
  it "'s subject should contain the class name of the exception" do
    send_monitoring_email

    expect(@subject).to include(@exception.class.name)
  end
  it "'s subject should contain the message of the exception" do
    send_monitoring_email

    expect(@subject).to include(@exception.message)
  end

  should_contain_the_logs

  it "'s body should contain the exception trace" do
    @exception.stub(:backtrace).and_return(["very long and complicated stack trace","frame 1","frame 2"])

    send_monitoring_email

    expect(@body).to include (@exception.backtrace.join("\n"))
  end

end
