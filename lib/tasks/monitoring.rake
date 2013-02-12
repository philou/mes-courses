# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

namespace "mes:courses" do

  desc "Sends a ping email to the admin"
  task "ping:email" => :environment do
    MonitoringMailer.ping.deliver
  end
end
