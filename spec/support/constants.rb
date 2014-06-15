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


module MesCourses
  module Stores
    module Carts

      # Testing constants added to the Api class
      module TestingCredentials
        def valid_email
          "valid@mail.com"
        end
        def valid_password
          "valid-password"
        end
        def invalid_email
          "in" + valid_email
        end
        def invalid_password
          "in" + valid_password
        end
      end

      Api.send(:extend, TestingCredentials)

    end
  end
end
