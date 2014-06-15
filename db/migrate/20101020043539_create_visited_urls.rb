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


# Marker for urls already visited during import. Allows
# to resume the import after an error
class CreateVisitedUrls < ActiveRecord::Migration
  def self.up
    create_table :visited_urls do |t|
      t.string :url
    end
  end

  def self.down
    drop_table :visited_urls
  end
end
