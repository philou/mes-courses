# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require "spec_helper"

describe "Schema" do

  it "uses infinite text columns instead of bounded string columns" do
    schema_def = IO.read(File.join(Rails.root, 'db', 'schema.rb'))

    schema_def.should_not include(':string')
  end

end
