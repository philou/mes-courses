# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

desc "Run specs depending on online thirdparty"
Spec::Rake::SpecTask.new :remote_spec do |t|
  t.pattern = "./remote_spec/**/*_spec.rb"
end
