# Copyright (C) 2010, 2011 by Philippe Bourgau

class DishController < ApplicationController

  before_filter :assign_html_body_id

  def index
    @dishes = Dish.find(:all)
  end

  private

  def assign_html_body_id
    @body_id = 'dish'
  end

end
