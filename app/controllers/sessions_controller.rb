# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class SessionsController < Devise::SessionsController
  include PathBarHelper

  force_ssl

  before_filter :assign_path_bar

  private
  def assign_path_bar
    self.path_bar= [path_bar_session_root]
  end
end
