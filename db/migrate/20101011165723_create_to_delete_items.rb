# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau
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


# Deletion marker table for items used during incremental import.
# This table is not supposed to be active recorded.
class CreateToDeleteItems < ActiveRecord::Migration
  def self.up
    create_table :to_delete_items, :primary_key => :item_id do |t|
      t.integer :item_id
    end
  end

  def self.down
    drop_table :to_delete_items
  end
end
