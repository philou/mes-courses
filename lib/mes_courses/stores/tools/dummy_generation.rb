# -*- coding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

require 'factory_girl_rails'
require File.join(Rails.root, 'spec/lib/mes_courses/stores/items/real_dummy_generator')

MesCourses::Stores::Items::RealDummy.host_dir_name = "local_stores"
