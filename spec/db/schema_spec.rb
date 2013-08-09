# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require "spec_helper"

describe "Schema" do

  it "uses infinite text columns instead of bounded string columns" do
    File.open(File.join(Rails.root, 'db', 'schema.rb'), "r") do |schema_file|

      lines = schema_file.each_line
      lines = lines.find_all {|line| line =~ /[^a-zA-Z0-9_]string[^a-zA-Z0-9_]/ } # get all lines with the word "string"
      lines = lines.find_all {|line| !(line =~ /t\.string\s+\"[^\"]*_type\"/)} # ignore polymorphic xxx_type columns

      expect(lines).to be_empty
    end
  end
end
