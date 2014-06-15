# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


describe "Array extras" do

  it "starting_with should work" do
    expect([:a,:b,:c]).to be_starting_with([])
    expect([:a,:b,:c]).to be_starting_with([:a])
    expect([:a,:b,:c]).to be_starting_with([:a, :b])
    expect([:a,:b,:c]).to be_starting_with([:a, :b, :c])

    expect([:a,:b,:c]).not_to be_starting_with([:c])
    expect([:a,:b,:c]).not_to be_starting_with([:a, :c])
    expect([:a,:b,:c]).not_to be_starting_with([:a, :b, :d])
    expect([:a,:b,:c]).not_to be_starting_with([:a, :b, :c, :d])
  end

  it "ending_with should work" do
    expect([:a,:b,:c]).to be_ending_with([])
    expect([:a,:b,:c]).to be_ending_with([:c])
    expect([:a,:b,:c]).to be_ending_with([:b, :c])
    expect([:a,:b,:c]).to be_ending_with([:a, :b, :c])

    expect([:a,:b,:c]).not_to be_ending_with([:a])
    expect([:a,:b,:c]).not_to be_ending_with([:a, :c])
    expect([:a,:b,:c]).not_to be_ending_with([:z, :b, :c])

    expect([:a,:b,:c]).not_to be_ending_with([:z, :a, :b, :c])
  end

  it "containing should work" do
    expect([:a,:b,:c]).to be_containing([])
    expect([:a,:b,:c]).to be_containing([:a])
    expect([:a,:b,:c]).to be_containing([:a, :b])
    expect([:a,:b,:c]).to be_containing([:a, :b, :c])
    expect([:a,:b,:c]).to be_containing([:b, :c])
    expect([:a,:b,:c]).to be_containing([:c])

    expect([:a,:b,:c]).not_to be_containing([:d])
    expect([:a,:b,:c]).not_to be_containing([:a, :c])
    expect([:a,:b,:c]).not_to be_containing([:c, :c, :c])

    expect([:a,:b,:c]).not_to be_containing([:c, :b, :c, :d])
  end

end
