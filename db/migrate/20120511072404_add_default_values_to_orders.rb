# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


class AddDefaultValuesToOrders < ActiveRecord::Migration

  def self.up
    change_column :orders, :status, :string, :null => false, :default => Order::NOT_PASSED
    change_column :orders, :warning_notices_text, :text, :null => false, :default => ""
    change_column :orders, :error_notice, :string, :null => false, :default => ""
    change_column :orders, :forwarded_cart_lines_count, :integer, :null => false, :default => 0
  end

  def self.down
    change_column :orders, :status, :string, :null => false
    change_column :orders, :warning_notices_text, :text, :null => false
    change_column :orders, :error_notice, :string, :null => false
    change_column :orders, :forwarded_cart_lines_count, :integer, :null => false
  end
end
