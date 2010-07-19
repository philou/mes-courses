class ItemsController < ApplicationController

  def show
    @items = Item.find(:all)
  end

end
