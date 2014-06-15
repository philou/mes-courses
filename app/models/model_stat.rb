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


# Stats about instances saved in the database
class ModelStat < ActiveRecord::Base

  attr_accessible :count, :name

  validates_presence_of :name, :count
  validates_uniqueness_of :name

  ITEM = "Item"
  ROOT_CATEGORY = "Root item category"
  CATEGORY = "Item category"

  ALL = [ROOT_CATEGORY, CATEGORY, ITEM]


  def self.update!
    count_rows().each do |name, stat|
      ModelStat.create_or_update_by_name!(name, :count => stat[:count])
    end
  end

  def self.generate_delta
    stats = count_rows()

    ModelStat.all.each do |model_stat|
      stats[model_stat.name][:old_count] = model_stat.count
    end

    stats.each do |_name, stat|
      old_count = stat[:old_count]
      if (old_count != 0)
        stat[:delta] = stat[:count].to_f / old_count.to_f
      end
    end

    stats
  end

  private

  def self.count_rows
    { "Root item category" => { :count => ItemCategory.count(:conditions => "parent_id is null"), :old_count => 0 },
      "Item category" => { :count => ItemCategory.count, :old_count => 0 },
      "Item" => { :count => Item.count, :old_count => 0 }}
  end

  def self.create_or_update_by_name!(name, attributes = {})
    result = find_or_initialize_by_name(name)
    result.update_attributes!(attributes)
    result
  end

end
