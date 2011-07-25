# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/monitoring_mailer_shared_examples'

describe WatchdogNotifier do
  it_should_behave_like "Any MonitoringMailer"

  before(:each) do
    @mailer_class = WatchdogNotifier
    @mailer_template = :success_email
    @mailer_default_parameters = []
  end

end
