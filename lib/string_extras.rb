# Copyright (C) 2011 by Philippe Bourgau

class String
  def starting_with?(prefix)
    index(prefix) == 0
  end
end
