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
  module Utils
    class Retrier

      def initialize(wrapped, options = {} )
        @wrapped = wrapped
        @options = { :max_retries => 1, :ignored_exceptions => [], :sleep_delay => 0, :wrap_result => [] }.merge(options)
      end

      def method_missing(method_sym, *args)
        wrap_result(method_sym, send_to_wrapped(method_sym, args))
      end

      private

      def wrap_result(method_sym, result)
        if !@options[:wrap_result].include?(method_sym) || result.nil?
          return result

        elsif result.respond_to?(:map)
          return result.map { |item| wrap(item) }

        else
          wrap(result)

        end
      end

      def wrap(object)
        Retrier.new(object, @options)
      end

      def send_to_wrapped(method_sym, args)
        retries = @options[:max_retries] - 1
        begin
          @wrapped.send(method_sym, *args)
        rescue Exception => exception
          if retries <= 0 || ignored?(exception)
            raise
          else
            Rails.logger.warn("Retrying on exception #{exception}, #{retries} attempts left.\n#{exception.backtrace.join("\n")}")
            sleep(@options[:sleep_delay])
            retries = retries - 1
            retry
          end
        end
      end

      def ignored?(exception)
        @options[:ignored_exceptions].any? {|exception_class| exception.instance_of?(exception_class) }
      end

    end
  end
end
