# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class WelcomeController < ApplicationController
  def index
    self.body_id= PRESENTATION_BODY_ID
  end
end
