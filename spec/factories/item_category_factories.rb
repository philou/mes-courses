# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau
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

  sequence :category_name do |n|
    "Category-#{n}"
  end

  factory :item_category do |category|
    category.name { FactoryGirl.generate(:category_name) }
  end

  sequence :sub_category_name do |n|
    "SubCategory-#{n}"
  end

  factory :item_sub_category, :class => ItemCategory do |category|
    category.name { FactoryGirl.generate(:sub_category_name) }
    category.parent { |a| a.association(:item_category) }
  end

end
