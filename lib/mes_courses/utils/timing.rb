# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

# Provides a timer to a block of code while executing
module MesCourses
  module Utils
    class Timing
      def self.duration_of
        yield new
      end

      def self.now
        Time.now
      end

      def seconds
        Timing.now - @t0
      end

      private

      def initialize
        @t0 = Timing.now
      end
    end
  end
end
