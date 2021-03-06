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

describe OrderMailer do

  before :each do
    @user = "john@doe.net"
    @dishes = FactoryGirl.create_list(:dish_with_items, 2)
  end

  it "sends an email to the user" do
    render_order_memo_email

    expect(@email).to deliver_to(@user)
  end

  it "uses an explicit subject" do
    render_order_memo_email

    expect(@email).to have_subject(OrderMailer::MEMO_SUBJECT)
  end

  it "lists dishes and their items" do
    render_order_memo_email

    @dishes.each do |dish|
      expect(@email).to have_body_text(summary_for(dish))
    end
  end

  it "pretty prints long names" do
    extra_long_dish_name = "Ceci est un super long nom pour un plat qui est vraiment très très difficile à faire mais qui est quand meme très bon"
    @dishes = [dish = FactoryGirl.create(:dish, name: extra_long_dish_name)]

    extra_long_item_name = "Ceci est un super long nom pour un ingrédient qui est vraiment très très bon mais aussi très très rare et très très cher"
    dish.items.push FactoryGirl.create(:item, name: extra_long_item_name)

    render_order_memo_email

    expect(@email.body.to_s.lines).to all_ { have_at_most(79).characters }
  end

  private

  def summary_for(dish)
    lines = [dish.name]
    lines += (dish.items.sort_by &:long_name).map do |item|
      "   * #{item.long_name}"
    end
    lines.join("\n")
  end

  def render_order_memo_email
    @email = OrderMailer.memo(@user, @dishes)
  end

end
