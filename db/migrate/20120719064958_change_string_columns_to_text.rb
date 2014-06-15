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


# change all string columns to text because
#  a. I had an unexpected length problem when I tried to migrate live data
#  b. It is not slower on PostGre databases
class ChangeStringColumnsToText < ActiveRecord::Migration

  def up
    change_column :delayed_jobs, :queue, :text
    change_column :dishes, :name, :text, null: false
    change_column :item_categories, :name, :text, null: false
    change_column :items, :name, :text, null: false
    change_column :items, :image, :text
    change_column :items, :summary, :text
    change_column :items, :tokens, :text, null: false
    change_column :model_stats, :name, :text, null: false
    change_column :orders, :error_notice, :text, null: false, default: ""
    change_column :orders, :status, :text, null: false, default: "not_passed"
    change_column :stores, :url, :text, null: false
    change_column :stores, :sponsored_url, :text, null: false
    change_column :users, :email, :text, null: false, default: ""
    change_column :users, :encrypted_password, :text, null: false, default: ""
    change_column :visited_urls, :url, :text, null: false
  end

  def down
    change_column :delayed_jobs, :queue, :string
    change_column :dishes, :name, :string, null: false
    change_column :item_categories, :name, :string, null: false
    change_column :items, :name, :string, null: false
    change_column :items, :image, :string
    change_column :items, :summary, :string
    change_column :items, :tokens, :string, null: false
    change_column :model_stats, :name, :string, null: false
    change_column :orders, :error_notice, :string, null: false, default: ""
    change_column :orders, :status, :string, null: false, default: "not_passed"
    change_column :stores, :url, :string, null: false
    change_column :stores, :sponsored_url, :string, null: false
    change_column :users, :email, :string, null: false, default: ""
    change_column :users, :encrypted_password, :string, null: false, default: ""
    change_column :visited_urls, :url, :string, null: false
  end

end
