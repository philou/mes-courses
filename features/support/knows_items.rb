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


module KnowsItems

  def create_items(table)
    table.hashes_with_defaults('name').each do |row|
      item = FactoryGirl.create(:item_with_categories, row)
    end
  end

  def there_should_be_the_following_items(table)
    visit_every_item_in(table) do |page, item, attributes|
      expect(page).to contain_an(item_with_name(item))
      attributes.each do |name, value|
        item_with_attribute = send("item_with_#{name}", item, value)
        expect(page).to contain_an(item_with_attribute)
      end
    end
  end

  def the_following_items_should_be_in_categories(table)
    visit_every_item_in(table) do |page, item|
      expect(page).to contain_an(item_with_name(item))
    end
  end

  def the_following_items_should_be_disabled(table)
    visit_every_item_in(table) do |page, item|
      expect(page).to contain_a(disabled_item_with_name(item))
    end
  end

  def the_following_items_should_have_been_deleted(table)
    visit_every_item_in(table) do |page, item|
      expect(page).not_to contain_a(item_with_name(item))
    end
  end

  def the_following_items_should_be_enabled(table)
    visit_every_item_in(table) do |page, item|
      expect(page).to contain_an(enabled_item_with_name(item))
    end
  end

  private

  def visit_every_item_in(table)
    table.each_item do |category, sub_category, item, attributes|
      visit item_categories_path
      click_link(category)
      click_link(sub_category)
      yield(page, item, attributes)
    end
  end

end
World(KnowsItems)
