# -*- encoding: utf-8 -*-
# Copyright (C) 2014 by Philippe Bourgau
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


class AddRemoteIdIndexToItem < ActiveRecord::Migration

  def self.up
    remove_index "items", :name => "items_name_item_sub_type_id"
    change_column "items", "remote_id", :integer, :null => false
    add_index "items", ["remote_id"], :name => "items_remote_id_index", :unique => true
  end

  def self.down
    remove_index "items", :name => "items_remote_id_index"
    change_column "items", "remote_id", :integer, :null => true
    add_index "items", ["name", "item_category_id"], :name => "items_name_item_sub_type_id", :unique => true
  end

end
