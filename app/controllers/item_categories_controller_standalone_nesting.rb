# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
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


class ItemCategoriesControllerStandaloneNesting
  include Rails.application.routes.url_helpers

  def root_path_bar
    []
  end

  public :item_categories_path, :item_category_path

  def add_item_label
    "Ajouter au panier"
  end
  def add_item_url_options
    {:controller => 'cart_lines', :action => 'create'}
  end
  def add_item_html_options
    {:method => :post}
  end

  def show_sub_category_url_options
    {:controller => 'item_categories', :action => 'show'}
  end
end
