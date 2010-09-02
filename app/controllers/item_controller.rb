# Copyright (C) 2010 by Philippe Bourgau

class ItemController < ApplicationController

  def show
    @items = Item.find(:all)
  end

end
