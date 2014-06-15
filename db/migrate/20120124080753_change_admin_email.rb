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


class ChangeAdminEmail < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  GOOGLE_EMAIL = "philippe.bourgau@gmail.com"
  MES_COURSES_EMAIL = "philippe.bourgau@mes-courses.fr"

  def self.up
    update_email(GOOGLE_EMAIL, MES_COURSES_EMAIL)
  end

  def self.down
    update_email(MES_COURSES_EMAIL, GOOGLE_EMAIL)
  end

  private
  def self.update_email(old_email, new_email)
    admin = User.find_by_email(old_email)
    unless admin.nil?
      admin.email = new_email
      admin.save!
    end
  end
end
