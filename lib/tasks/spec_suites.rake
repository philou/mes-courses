# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

#unless Rails.env == "production"

  desc "Run specs depending on online thirdparty"
  RSpec::Core::RakeTask.new :remote_spec do |t|
    t.spec_opts = %{--tag @remote}
  end

  desc "Run slow specs"
  RSpec::Core::RakeTask.new :slow_spec do |t|
    t.spec_opts = %{--tag @slow}
  end

  desc "Run fast specs"
  RSpec::Core::RakeTask.new :fast_spec do |t|
    t.spec_opts = %{--tag ~@slow}
  end

#end
