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


class CreateModelStats < ActiveRecord::Migration

  INDEX_NAME = 'model_name_name_index'

  def self.up
    create_table :model_stats do |t|
      t.string :name, :null => false
      t.integer :count, :null => false

      t.timestamps
    end

    add_index :model_stats, :name, :name => INDEX_NAME, :unique => true
  end

  def self.down
    remove_index :model_stats, :name => INDEX_NAME
    drop_table :model_stats
  end
end
