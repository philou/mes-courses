# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses
  module Utils
    class Password

      def self.generate(size = 3)
        c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr lt bl)
        v = %w(a e i o u y)

        result = (0..(size * 2)).map do |i|
          if i.even?
            v[rand * v.size]
          else
            c[rand * c.size]
          end
        end
        result.join
      end

    end
  end
end
