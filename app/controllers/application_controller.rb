# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  MAIN_APP_PART = "app"
  BLOG_APP_PART = "blog"

  NO_BODY_ID = ''
  PRESENTATION_BODY_ID = 'presentation'
  BLOG_BODY_ID = 'blog'
  CART_BODY_ID = 'cart'
  DISHES_BODY_ID = 'dish'
  ITEMS_BODY_ID = 'items'
  SESSION_BODY_ID = 'session'

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :assign_session_place

  attr_reader :path_bar, :body_id
  attr_accessor :app_part

  def path_bar=(path_bar)
    @path_bar = path_bar
    self.body_id= extract_body_id(path_bar)
  end

  def body_id=(body_id)
    @body_id = body_id
    @app_part = extract_app_part(body_id)
  end

  private

  def extract_app_part(body_id)
    case body_id
    when PRESENTATION_BODY_ID
      BLOG_APP_PART
    when BLOG_BODY_ID
      BLOG_APP_PART
    else
      MAIN_APP_PART
    end
  end

  def extract_body_id(path_bar)
    path_bar_root = path_bar[0]

    return NO_BODY_ID if path_bar_element_with_no_link?(path_bar_root)

    case path_bar_root
    when path_bar_cart_lines_root
      CART_BODY_ID
    when path_bar_dishes_root
      DISHES_BODY_ID
    when path_bar_items_root
      ITEMS_BODY_ID
    when path_bar_session_root
      SESSION_BODY_ID
    else
      raise ArgumentError.new("Unhandled path bar root : #{path_bar_root.inspect}")
    end
  end

  def assign_session_place
    unless user_signed_in?
      @session_place_text = 'Connection'
      @session_place_url = main_app.new_user_session_path
    else
      @session_place_text = "Deconnection (#{current_user.email})"
      @session_place_url = main_app.destroy_user_session_path
    end
  end

end
