# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau
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


require_relative "../constants"

class AddSponsoredLinkToStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :sponsored_url, :string
    execute "UPDATE stores set sponsored_url = url"
    execute "UPDATE stores set sponsored_url = '#{DB::Constants::AUCHAN_DIRECT_AFFILINET_URL}' where url = '#{DB::Constants::AUCHAN_DIRECT_URL}'"
    change_column :stores, :sponsored_url, :string, :null => false
  end

  def self.down
    remove_column :stores, :sponsored_url
  end
end
