# Copyright (C) 2010 by Philippe Bourgau

class ItemController < ApplicationController

  def index
    @items = Item.find(:all)
  end

end
