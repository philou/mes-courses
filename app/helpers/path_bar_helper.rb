# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


module PathBarHelper

  # Path bar element with no link
  def path_bar_element_with_no_link(text)
    text
  end
  def path_bar_element_with_no_link?(element)
    element.instance_of?(String)
  end

  # path bar element with a default link (current controller and action)
  # ignores eventual GET parameters
  def path_bar_element_for_current_resource(text)
    [text]
  end

  # path bar element with a link to url_for(options)
  def path_bar_element(text, url_for_options = {})
    [text, url_for_options]
  end

  def path_bar_dishes_root
    path_bar_element('Recettes', dishes_path)
  end

  def path_bar_items_root
    path_bar_element("Ingrédients", item_categories_path)
  end

  def path_bar_cart_lines_root
    path_bar_element("Panier", cart_lines_path)
  end

  def path_bar_session_root
    path_bar_element("Connection", new_user_session_path)
  end

end
