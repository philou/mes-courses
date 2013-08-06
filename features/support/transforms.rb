# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

CAPTURE_PERCENTAGE = Transform(/^\d+%$/) do |digits|
  digits.to_f
end

CAPTURE_STORE_NAME = Transform(/^(a|the) ?"?([^" ]*)"? store$/) do |_prefix, store_name|
  if store_name == ""
    main_store_name
  else
    store_name
  end
end

CAPTURE_AMOUNT = Transform(/^(\d+(\.\d+)?)€$/) do |whole, _fraction|
  whole.to_f
end
