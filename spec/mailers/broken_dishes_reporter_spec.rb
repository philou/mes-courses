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


require 'spec_helper'
require 'lib/mes_courses/rails_utils/monitoring_mailer_base_shared_examples'

describe BrokenDishesReporter do
  include MesCourses::RailsUtils::MonitoringMailerBaseSpecMacros

  it_should_behave_like_any_monitoring_mailer

  before(:each) do
    @mailer_class = BrokenDishesReporter
    @mailer_template = :email
    @mailer_default_parameters = [[]]
  end

  it "should have a subject about broken dishes" do
    send_monitoring_email

    expect(@subject).to include("broken dishes")
  end

  it "should contain the yaml of all removed items" do
    removed_items = [FactoryGirl.create(:item_with_categories), FactoryGirl.create(:item_with_categories)]

    send_monitoring_email removed_items

    removed_items.each do |item|
      expect(@body).to include(item.attributes.to_yaml)
    end
  end

  it "should contain the id and name of all broken dishes" do
    removed_item = FactoryGirl.create(:item_with_categories)
    removed_item.dishes = [FactoryGirl.create(:dish_with_items), FactoryGirl.create(:dish_with_items)]

    send_monitoring_email [removed_item]

    removed_item.dishes.each do |dish|
      expect(@body).to include("##{dish.id}# #{dish.name}")
    end
  end

end
