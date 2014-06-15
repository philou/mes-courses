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

describe "orders/login" do

  before(:each) do
    assign :order, @order = FactoryGirl.build(:order)
    assign :store_login_parameters, @store_login_parameters = @order.store_login_parameters(FactoryGirl.build(:credentials))
  end

  it "renders the login form to the online store" do
    render

    expect(response).to have_selector("form", action: @order.store_login_url, method: 'post') do |form|
      @store_login_parameters.each do |parameter|
        expect(form).to have_selector("input", type: 'hidden', value: parameter['value'])
      end
      expect(form).to have_selector("input", type: 'submit', value: "Connectez-vous sur #{@order.store_name} pour payer")
    end
  end

  it "'s login form always opens in a new tab" do
    render

    expect(response).to have_selector("form", action: @order.store_login_url, target: '_blank')
  end

  it "renders forward report warnings" do
    2.times { @order.add_missing_cart_line(FactoryGirl.build(:cart_line)) }

    render

    expect(rendered).to have_selector("div", class: "warning") do |div|
      @order.warning_notices.each do |notice|
        expect(div).to contain(notice)
      end
    end
  end

end

