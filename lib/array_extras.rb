# Copyright (C) 2011 by Philippe Bourgau

class Array
  def starting_with?(prefix)
    prefix.empty? || slice(0..prefix.size - 1) == prefix
  end
  def ending_with?(suffix)
    slice(size-suffix.size..size-1) == suffix
  end

  def containing?(subarray)
    return true if subarray.empty?

    each_with_index do |item, i|
      if item == subarray[0]
        return true if slice(i..i + subarray.size - 1) == subarray
      end
    end

    return false
  end
end
