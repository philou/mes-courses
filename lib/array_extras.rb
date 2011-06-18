# Copyright (C) 2011 by Philippe Bourgau

class Array
  def starting_with?(prefix)
    prefix.empty? || slice(0..prefix.size - 1) == prefix
  end
  def ending_with?(suffix)
    slice(size-suffix.size..size-1) == suffix
  end
end
