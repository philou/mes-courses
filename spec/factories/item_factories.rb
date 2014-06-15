# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013, 2014 by Philippe Bourgau
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

  sequence :item_name do |n|
    "Item-#{n}"
  end
  sequence :remote_id do |n|
    n.to_s
  end

  sequence :price do |n|
    (n.to_f / 100 + 1.0).to_f
  end

  factory :item do
    name { FactoryGirl.generate(:item_name) }
    brand { |a| "#{a.name} Corp." }
    image { |a| "http://www.image.org/#{a.name}" }
    remote_id { FactoryGirl.generate(:remote_id) }
    price { FactoryGirl.generate(:price) }

    factory :item_with_categories do
      after :create do |item|
        item.item_categories = FactoryGirl.create_list(:item_sub_category, 1, items: [item])
      end
    end
  end

end

# custom factory function with a named organization
def categorized_item (category_name, sub_category_name, options = {})
  category = ItemCategory.find_or_create_by_name_and_parent_id(category_name, ItemCategory.root.id)
  sub_category = ItemCategory.find_or_create_by_name_and_parent_id(sub_category_name, category.id)

  FactoryGirl.create(:item, {item_categories: [sub_category]}.merge(options))
end
