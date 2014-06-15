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


describe "String extras" do

  it "starting_with? should work with string prefix" do
    expect("Nice weather today").to be_starting_with("Nice")
    expect("Bad weather today").not_to be_starting_with("Nice")
    expect("Whatever").to be_starting_with("")
    expect("Sunny weather today").not_to be_starting_with("Sunny t")
  end

  it "starting_with? should work with regexp prefix" do
    expect("Nice weather today").to be_starting_with(/Nice/)
    expect("Bad weather today").not_to be_starting_with(/[NM]/)
    expect("Whatever").to be_starting_with(//)
    expect("Sunny weather today").not_to be_starting_with("Sunny [a-c]")
  end

end

