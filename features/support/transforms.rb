# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

CAPTURE_PERCENTAGE = Transform /^(\d+)%$/ do |digits|
  digits.to_f
end
