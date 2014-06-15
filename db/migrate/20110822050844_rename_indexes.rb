# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau
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


class RenameIndexes < ActiveRecord::Migration
  def self.up
    remove_index "dishes", :name => "dishes_name"
    add_index "dishes", ["name"], :name => "dishes_name_index", :unique => true

    remove_index "dishes_items", :name => "dishes_items_dish_id"
    add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id_index"

    remove_index "dishes_items", :name => "dishes_items_item_id"
    add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id_index"

    remove_index "item_categories", :name => "item_sub_types_name_item_type_id"
    add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id_index", :unique => true

    remove_index "stores", :name => "stores_url"
    add_index "stores", ["url"], :name => "stores_url_index", :unique => true

    remove_index "visited_urls", :name => "visited_urls_url"
    add_index "visited_urls", ["url"], :name => "visited_urls_url_index", :unique => true
  end

  def self.down
    remove_index "dishes", :name => "dishes_name_index"
    add_index "dishes", ["name"], :name => "dishes_name", :unique => true

    remove_index "dishes_items", :name => "dishes_items_dish_id_index"
    add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id"

    remove_index "dishes_items", :name => "dishes_items_item_id_index"
    add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id"

    remove_index "item_categories", :name => "item_sub_types_name_item_type_id_index"
    add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id", :unique => true

    remove_index "stores", :name => "stores_url_index"
    add_index "stores", ["url"], :name => "stores_url", :unique => true

    remove_index "visited_urls", :name => "visited_urls_url_index"
    add_index "visited_urls", ["url"], :name => "visited_urls_url", :unique => true
  end

  private
end
