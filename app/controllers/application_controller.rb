# Copyright (C) 2010, 2011 by Philippe Bourgau

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotification::ExceptionNotifiable

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  attr_reader :path_bar, :body_id

  def path_bar=(path_bar)
    @path_bar = path_bar
    @body_id = extract_body_id(path_bar)
  end

  private

  def extract_body_id(path_bar)
    path_bar_root = path_bar[0]
    case path_bar_root
    when path_bar_cart_lines_root
      'cart'
    when path_bar_dishes_root
      'dish'
    when path_bar_items_root
      'items'
    else
      raise ArgumentError.new("Unhandled path bar root : #{path_bar_root.inspect}")
    end
  end

end
