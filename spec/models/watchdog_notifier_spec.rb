# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/monitoring_mailer_shared_examples'

describe WatchdogNotifier do

  before(:each) do
    @mailer_class = WatchdogNotifier
    @mailer_template = :success_email
    @mailer_default_parameters = []
  end

  it_should_behave_like "Any MonitoringMailer"

  should_contain_the_logs

end
