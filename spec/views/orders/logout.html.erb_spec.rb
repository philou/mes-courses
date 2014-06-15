# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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
require_relative 'transfer_shared_examples'

describe "orders/logout" do

  it_behaves_like "a view with order transfer"

  it "renders an iframe to unlog the client from the remote store" do
    assign :order, @order = FactoryGirl.build(:order)

    render

    expect(rendered).to have_xpath("//iframe[@class='remote-store-iframe'][@src='#{@order.store_logout_url}']")
  end

end

