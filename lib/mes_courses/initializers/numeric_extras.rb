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


# extends Numeric to pretty print seconds as a duration
class Numeric

  def to_pretty_duration
    total_seconds = to_i
    seconds = total_seconds % 60

    total_minutes = (total_seconds / 60).to_i
    minutes = total_minutes % 60

    hours = (total_minutes / 60).to_i

    "#{hours}h #{minutes}m #{seconds}s"
  end

end
