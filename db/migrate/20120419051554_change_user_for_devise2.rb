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


class ChangeUserForDevise2 < ActiveRecord::Migration

  def up

    change_column :users, :encrypted_password, :string, :null => false, :default => ""
    remove_column :users, :password_salt

    add_index :users, :email, :unique => true, :name => "users_email_index"

    execute "delete from users where email != 'philippe.bourgau@mes-courses.fr'"
    execute "update users set encrypted_password = '$2a$10$U/s1U3tZvRxc0KmtLRkOauypnS0odvo44xdXgwZ5FClWQ95JLlGFW' where email = 'philippe.bourgau@mes-courses.fr'"
  end

  def down

    remove_index :users, :name => "users_email_index"

    change_column :users, :encrypted_password, :string, :limit => 128, :null => false, :default => ""
    add_column :users, :password_salt, :string

    execute "delete from users where email != 'philippe.bourgau@mes-courses.fr'"
    execute "update users set encrypted_password = '959720a131da16c6a88b4e38da13427cd1ab731d', password_salt = 'gDuEpxJd9Q-T-aHgqj3z' where email = 'philippe.bourgau@mes-courses.fr'"

    change_column :users, :password_salt, :string, :null => false, :defaut => ""
  end
end
