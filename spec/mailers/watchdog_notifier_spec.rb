# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require 'lib/mes_courses/rails_utils/monitoring_mailer_shared_examples'

describe WatchdogNotifier do
  include MesCourses::RailsUtils::MonitoringMailerSpecMacros

  before(:each) do
    @mailer_class = WatchdogNotifier
    @mailer_template = :success_email
    @mailer_default_parameters = []
  end

  it_should_behave_like_any_monitoring_mailer

  should_contain_the_logs

end
