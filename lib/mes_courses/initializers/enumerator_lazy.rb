# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class Enumerator::Lazy

  def flatten(depth = Float::INFINITY)
    return self if depth <= 0

    Enumerator::Lazy.new(self) do |yielder, item|
      if item.is_a? Enumerable
        item.lazy.flatten(depth - 1).each do |e|
          yielder.yield(e)
        end
      else
        yielder.yield(item)
      end
    end
  end

end
