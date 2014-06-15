# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau
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

shared_examples "a view with order transfer" do |store_parameters = {}|

  before(:each) do
    assign :order, @order = FactoryGirl.build(:order)
    assign :forward_completion_percents, @forward_completion_percents = 47
    render
  end

  it "renders the name of the store" do
    expect(rendered).to contain(@order.store_name)
  end

  it "renders the passing progress ratio" do
    expect(rendered).to contain('47%')
  end

end
