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


class Array
  def starting_with?(prefix)
    prefix.empty? || slice(0..prefix.size - 1) == prefix
  end
  def ending_with?(suffix)
    slice(size-suffix.size..size-1) == suffix
  end

  def containing?(subarray)
    return true if subarray.empty?

    each_with_index do |item, i|
      if item == subarray[0]
        return true if slice(i..i + subarray.size - 1) == subarray
      end
    end

    return false
  end
end
