# -*- coding: utf-8 -*-
# Copyright (C) 2012, 2013, 2014 by Philippe Bourgau

require 'storexplore/testing/dummy_store_generator'

Storexplore::Testing.config do |config|
  config.dummy_store_generation_dir = "local_stores"
end

