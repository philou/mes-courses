# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require_relative "mes_courses/initializers"

module MesCourses
  autoload_relative_ex :Utils, "utils"
  autoload_relative_ex :StoreCart, "store_cart"
  autoload_relative_ex :Deployment, "deployment"
end
