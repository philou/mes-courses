# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class FeaturesController < ApplicationController
  include PathBarHelper

  def index
    self.path_bar = [path_bar_element_with_no_link("Fonctionalités")]
  end

end
