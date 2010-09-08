class ItemTypeController < ApplicationController

  def index
    @item_types = ItemType.find(:all)
  end

  def show
    @item_type = ItemType.find_by_id(params[:id])
  end

end
