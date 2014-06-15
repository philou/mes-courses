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


module KnowsDishes

  def create_dishes(table)
    table.hash_2_lists.each do |name, items_long_names|
      items = items_long_names.map do |item_long_name|
        FactoryGirl.create(:item_with_categories, parse_attributes(item_long_name))
      end

      FactoryGirl.create(:dish, name: name, items: items)
    end
  end

  private

  BRAND_AND_NAME = /([A-Z ]+,)? ?(.*)/

  def parse_attributes(item_long_name)
    brand, name = BRAND_AND_NAME.match(item_long_name)[1..2]

    result = {name: name}
    result[:brand] = brand unless brand.nil?

    result
  end

end
World(KnowsDishes)
