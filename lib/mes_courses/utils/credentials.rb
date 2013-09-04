# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

module MesCourses
  module Utils
    class Credentials
      def initialize(email,password)
        @email = email
        @password = password.encrypt(key: encryption_key)
      end

      def email
        @email
      end

      def password
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
