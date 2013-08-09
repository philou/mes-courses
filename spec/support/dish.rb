# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require "dish"

class Dish
  def that_is_disabled
    items << FactoryGirl.create(:item).that_is_disabled
    self
  end
  alias :disable :that_is_disabled
end
