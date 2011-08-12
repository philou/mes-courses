# Copyright (C) 2011 by Philippe Bourgau

class Order < ActiveRecord::Base

  belongs_to :cart
  belongs_to :store

  validates_presence_of :forwarded_cart_lines_count

  def initialize(attributes = {})
    defaults = { :missing_items_names => "", :forwarded_cart_lines_count => 0}
    super(defaults.merge(attributes))
  end

end
