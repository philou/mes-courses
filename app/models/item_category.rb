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


# Hierarchichal category of items,
class ItemCategory < ActiveRecord::Base
  include MesCourses::RailsUtils::SingletonBuilder

  attr_accessible :parent, :name

  has_and_belongs_to_many :items
  acts_as_tree :order => "name"

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "parent_id"

  singleton(:root, Constants::ROOT_ITEM_CATEGORY_NAME)
  singleton(:disabled, Constants::DISABLED_ITEM_CATEGORY_NAME)
end
