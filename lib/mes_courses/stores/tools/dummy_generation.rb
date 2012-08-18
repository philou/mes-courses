# -*- coding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

require 'factory_girl_rails'
require File.join(Rails.root, 'spec', 'models', 'real_dummy_store_generator')

RealDummyStore.host_dir_name = "local_stores"
