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


# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include MesCourses::Utils::HerokuHelper
  include MesCourses::Utils::UrlHelper

  def self.included(base)
    base.send :include, PathBarHelper
  end

  def root_item_category_path
    item_category_path(ItemCategory.root)
  end

  # path for a category, defaults to the main browser for a nil or new category
  def any_item_category_path(*args)
    return root_item_category_path if args.empty?

    category = args[0]
    return root_item_category_path if category.nil? || category.id.nil?

    item_category_path(*args)
  end

  def google_analytics_enabled?
    ENV["GOOGLE_ANALYTICS_ENABLED"] == true.to_s
  end

  def meta_http_equiv_refresh_tag
    refresh_strategy = @refresh_strategy || MesCourses::HtmlUtils::PageRefreshStrategy.none
    refresh_strategy.to_html
  end

end
