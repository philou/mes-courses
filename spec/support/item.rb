# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module ItemSpecExtensions
  def that_is_disabled
    item_categories << ItemCategory.disabled
    self
  end
  alias :disable :that_is_disabled
end

class Item
  include ItemSpecExtensions
end
