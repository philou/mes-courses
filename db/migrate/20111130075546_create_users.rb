# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau
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


class CreateUsers < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  def self.up
    create_table :users do |t|
      ## Database authenticable
      t.string   "email",                             :default => "", :null => false
      t.string   "encrypted_password", :limit => 128, :default => "", :null => false
      t.string   "password_salt",                     :default => "", :null => false

      t.timestamps
    end

    boss = User.new
    boss.email = 'philippe.bourgau@gmail.com'
    boss.encrypted_password = "959720a131da16c6a88b4e38da13427cd1ab731d"
    boss.password_salt = "gDuEpxJd9Q-T-aHgqj3z"
    boss.save!
  end

  def self.down
    drop_table :users
  end
end
