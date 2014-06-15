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


# Decrease the expected items of auchandirect store to 6000 because 7000 was often too high
class DecreaseAuchanDirectExpectedItems < ActiveRecord::Migration
  def self.up
    execute "UPDATE stores SET expected_items = 6000 WHERE url = 'http://www.auchandirect.fr'"
  end

  def self.down
    execute "UPDATE stores SET expected_items = 7000 WHERE url = 'http://www.auchandirect.fr'"
  end
end
