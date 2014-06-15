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


class RenameItemNameSummaryToBrandName < ActiveRecord::Migration
  def up
    rename_column :items, :name, :brand
    rename_column :items, :summary, :name

    execute %{UPDATE items SET name = '#{Constants::LOST_ITEM_NAME}' WHERE brand = '#{Constants::LOST_ITEM_NAME}'}

    change_column :items, :name, :text, null: false
    change_column :items, :brand, :text, null: true

    execute %{UPDATE items SET brand = null WHERE name = '#{Constants::LOST_ITEM_NAME}'}
  end

  def down
    execute %{UPDATE items SET brand = '#{Constants::LOST_ITEM_NAME}' WHERE name = '#{Constants::LOST_ITEM_NAME}'}

    change_column :items, :brand, :text, null: false
    change_column :items, :name, :text, null: true

    execute %{UPDATE items SET name = null WHERE brand = '#{Constants::LOST_ITEM_NAME}'}

    rename_column :items, :name, :summary
    rename_column :items, :brand, :name
  end
end
