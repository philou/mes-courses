# Copyright (C) 2010 by Philippe Bourgau

class ItemSubTypeController < ApplicationController
  def show
    @item_sub_type = ItemSubType.find_by_id(params[:id])
  end

end
