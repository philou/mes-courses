# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class WelcomeController < ApplicationController
  def index
    redirect_to :controller => 'dishes'
  end
end
