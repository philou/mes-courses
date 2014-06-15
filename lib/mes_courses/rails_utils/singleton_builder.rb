# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
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
  module RailsUtils

    module SingletonBuilder

      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        def singleton(symbol, name, &block)
          eigenclass = class << self; self; end

          eigenclass.instance_eval do
            define_method("#{symbol}_name") do
              name
            end
            define_method(symbol) do
              find_or_create_by_name!(name, &block)
            end
          end

          define_method("#{symbol}?") do
            self.name == name
          end
        end
      end
    end
  end
end
