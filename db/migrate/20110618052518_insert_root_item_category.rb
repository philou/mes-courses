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


class InsertRootItemCategory < ActiveRecord::Migration

  class ItemCategory < ActiveRecord::Base
    acts_as_tree :order => "name"
    attr_protected nil
  end

  def self.up
    top_categories = ItemCategory.find(:all, :conditions => {:parent_id => nil})
    ItemCategory.create!(:name => Constants::ROOT_ITEM_CATEGORY_NAME, :children => top_categories)
  end

  def self.down
    root_category = ItemCategory.find_by_name(Constants::ROOT_ITEM_CATEGORY_NAME)
    unless root_category.nil?
      root_category.children.each do |category|
        category.parent = nil
        category.save!
      end
      root_category.delete
    end
  end
end
