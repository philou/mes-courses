# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotification::ExceptionNotifiable
  include SslRequirement

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :assign_session_place

  attr_reader :path_bar, :body_id

  def path_bar=(path_bar)
    @path_bar = path_bar
    @body_id = extract_body_id(path_bar)
  end

  def ssl_required?
    return false if local_request? || RAILS_ENV == 'test'
    super
  end

  private

  def extract_body_id(path_bar)
    path_bar_root = path_bar[0]

    return '' if path_bar_element_with_no_link?(path_bar_root)

    case path_bar_root
    when path_bar_cart_lines_root
      'cart'
    when path_bar_dishes_root
      'dish'
    when path_bar_items_root
      'items'
    when path_bar_session_root
      'session'
    else
      raise ArgumentError.new("Unhandled path bar root : #{path_bar_root.inspect}")
    end
  end

  def assign_session_place
    unless user_signed_in?
      @session_place_text = 'Connection'
      @session_place_url = new_user_session_path
    else
      @session_place_text = "Deconnection (#{current_user.email})"
      @session_place_url = destroy_user_session_path
    end
  end

end
