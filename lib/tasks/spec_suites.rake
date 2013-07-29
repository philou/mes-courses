# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

desc "Run specs depending on online thirdparty"
RSpec::Core::RakeTask.new :remote_spec do |t|
  t.rspec_opts = %{--tag @remote}
end

desc "Run slow specs"
RSpec::Core::RakeTask.new :slow_spec do |t|
  t.rspec_opts = %{--tag @slow}
end

desc "Run fast specs"
RSpec::Core::RakeTask.new :fast_spec do |t|
  t.rspec_opts = %{--tag ~@slow}
end
