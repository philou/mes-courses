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





module NamespaceA
  class AClass
  end
  module NamespaceB
    class ABClass
    end
  end
end

module NamespaceC

  class CClass
    include NamespaceA::NamespaceB

    def self.write_something_intelligent
      puts ABClass.to_s
    end

    def write_something_else
      puts ABClass.to_s
    end
  end

end

NamespaceC::CClass.write_something_intelligent

NamespaceC::CClass.new.write_something_else

