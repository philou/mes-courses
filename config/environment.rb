# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8


# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MesCourses::Application.initialize!
