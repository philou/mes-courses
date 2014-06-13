# Copyright (C) 2014 by Philippe Bourgau


#!/bin/usr/env ruby

require_relative '../deployment'
include MesCourses::Deployment

with_trace_argument "INTERNAL USE : finishes integration" do
  integrate
end
