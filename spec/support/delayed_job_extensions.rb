# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

class Object

  def skip_delay
    stub(:delay).and_return(self)
  end
end
