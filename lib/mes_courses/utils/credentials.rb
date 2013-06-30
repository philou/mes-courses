# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module MesCourses
  module Utils
    class Credentials
      def initialize(login,password)
        @login = login
        @password = password.encrypt(key: encryption_key)
      end

      def login
        @login
      end

      def password
        @password.decrypt(key: encryption_key)
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

      private

      def encryption_key
        ENV['ENCRYPTION_KEY']
      end
    end
  end
end
