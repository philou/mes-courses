# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

# helper stub methods for spec examples
module StubHelper

  # overwrites methods on an existing instance with null_object return values
  def stub_with_null_object!(instance, *methods)
    stub_args = {}
    methods.each do |method|
      stub_args[method] = stub("#{instance} #{method} return stub").as_null_object
    end
    instance.stub!(stub_args)
  end

end
