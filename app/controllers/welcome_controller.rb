# Copyright (C) 2011 by Philippe Bourgau

class WelcomeController < ApplicationController
  def index
    redirect_to :controller => 'dish'
  end
end
