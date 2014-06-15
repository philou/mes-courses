# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
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


require 'spec_helper'

describe Dish do

  before :each do
    @dish = Dish.new()
    @dish.items = FactoryGirl.build_list(:item, 2)
  end

  it "is currently not disabled" do
    expect(@dish).not_to be_disabled
  end

  it "is disabled if one of its items is disabled" do
    @dish.items << FactoryGirl.build(:item).that_is_disabled

    expect(@dish).to be_disabled
  end

end
