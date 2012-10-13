# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class CguController < ApplicationController
  def index
    self.app_part= BLOG_APP_PART
  end
end
