# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


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
