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


FactoryGirl.define do

  sequence :dish_name do |n|
    "Dish-#{n}"
  end

  factory :dish do
    name { FactoryGirl.generate(:dish_name) }

    factory :dish_with_items do
      after :create do |dish|
        dish.items = FactoryGirl.create_list(:item_with_categories, 2, dishes: [dish])
      end
    end
  end

end
