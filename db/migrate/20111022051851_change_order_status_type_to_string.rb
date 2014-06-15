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


class ChangeOrderStatusTypeToString < ActiveRecord::Migration

  STATUSES = [Order::NOT_PASSED, Order::PASSING, Order::SUCCEEDED, Order::FAILED ]

  def self.up
    add_column :orders, :status_as_string, :string
    STATUSES.each_with_index do |as_string, as_int|
      execute "UPDATE orders set status_as_string = '#{as_string}' where status = #{as_int}"
    end
    change_column :orders, :status_as_string, :string, :null => false

    remove_column :orders, :status
    rename_column :orders, :status_as_string, :status
  end

  def self.down
    add_column :orders, :status_as_int, :integer
    STATUSES.each_with_index do |as_string, as_int|
      execute "UPDATE orders set status_as_int = #{as_int} where status = '#{as_string}'"
    end
    change_column :orders, :status_as_int, :integer, :null => false

    remove_column :orders, :status
    rename_column :orders, :status_as_int, :status
  end
end
