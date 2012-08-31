# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

require "item"

class Item
  def that_is_disabled
    item_categories << ItemCategory.disabled
    self
  end
  alias :disable :that_is_disabled
end
