# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau
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


class AddRootItemCategoryRules < ActiveRecord::Migration
  def self.up
    root_cat = ItemCategory.root

    execute "CREATE RULE prevent_delete_of_root_item_category AS ON DELETE TO item_categories WHERE old.id = #{root_cat.id} DO INSTEAD NOTHING;"
  end

  def self.down
    execute "DROP RULE prevent_delete_of_root_item_category ON item_categories;"
  end
end
