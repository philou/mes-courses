# Copyright (C) 2014 by Philippe Bourgau
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





klass = Class.new do
  self.send(:define_method, :get_toto) do
    @toto
  end
  self.send(:define_method, :set_toto) do |value|
    @toto = value
  end
end

k = klass.new

k.set_toto("k")
puts k.get_toto

k2 = klass.new
k2.set_toto("k2")
puts k2.get_toto

puts klass.instance_variable_get(:@toto)
puts @toto
