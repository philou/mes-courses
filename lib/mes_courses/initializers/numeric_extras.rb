# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

# extends Numeric to pretty print seconds as a duration
class Numeric

  def to_pretty_duration
    total_seconds = to_i
    seconds = total_seconds % 60

    total_minutes = (total_seconds / 60).to_i
    minutes = total_minutes % 60

    hours = (total_minutes / 60).to_i

    "#{hours}h #{minutes}m #{seconds}s"
  end

end
