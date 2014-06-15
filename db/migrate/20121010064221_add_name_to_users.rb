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


class AddNameToUsers < ActiveRecord::Migration

  INDEX_NAME = "users_name_index"

  def self.up
    add_column :users, :name, :text

    execute %{UPDATE users SET name = email}

    change_column :users, :name, :text, :null => false
    add_index :users, :name, name: INDEX_NAME, unique: true

    execute %{UPDATE users SET name = 'Philippe' WHERE name = 'philippe.bourgau@mes-courses.fr' }
  end

  def self.down
    remove_index :users, name: INDEX_NAME
    remove_column :users, :name
  end
end
