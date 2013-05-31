# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module MesCourses
  module Utils
    class Credentials
      def initialize(login,password)
        @login = login
        @password = password
      end

      def login
        @login
      end

      def password
        @password
      end

      def eql?(other)
        return !other.nil? &&
          other.instance_of?(self.class) &&
          login == other.login &&
          password == other.password
      end
      alias :== :eql?

      def to_s
        "(#{login},#{password})"
      end
    end
  end
end
