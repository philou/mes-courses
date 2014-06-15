# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau
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
  module Utils
    class Credentials
      def initialize(email,password)
        @email = email
        @password = ''
        @password = password.encrypt(key: encryption_key) unless password.blank?
      end

      def self.blank
        self.new('','')
      end

      def email
        @email
      end

      def password
        return '' if @password.blank?

        @password.decrypt(key: encryption_key)
      end

      def eql?(other)
        return !other.nil? &&
          other.instance_of?(self.class) &&
          email == other.email &&
          password == other.password
      end
      alias :== :eql?

      def to_s
        "(#{email},#{password})"
      end

      private

      def encryption_key
        ENV['ENCRYPTION_KEY']
      end
    end
  end
end
