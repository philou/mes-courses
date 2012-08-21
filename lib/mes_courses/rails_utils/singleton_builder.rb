# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

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
