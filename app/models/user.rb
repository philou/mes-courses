# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class User < ActiveRecord::Base
  devise :database_authenticatable, :encryptable

  #attr_accessible ... everything at the moment
  # think of advanced rails receipe #66 before extending this class

end
