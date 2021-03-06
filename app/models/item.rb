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


# An item for sale
class Item < ActiveRecord::Base
  include MesCourses::RailsUtils::SingletonBuilder

  has_and_belongs_to_many :dishes
  has_and_belongs_to_many :item_categories

  validates_presence_of :name, :tokens
  validates_presence_of :remote_id, unless: :lost?
  validates_uniqueness_of :remote_id
  validates_presence_of :price, unless: :lost?

  attr_protected :tokens

  after_initialize :index

  singleton :lost, Constants::LOST_ITEM_NAME do |record|
    record.item_categories.push(ItemCategory.disabled)
  end

  def self.all_but_lost
    where("id <> #{lost.id}")
  end

  def disabled?
    item_categories.include?(ItemCategory.disabled)
  end

  def image
    if disabled?
      "/images/disabled.png"
    else
      read_attribute("image") || "/images/unknown.png"
    end
  end

  def brand=(brand)
    write_attribute("brand", brand)
    index
  end
  def name=(name)
    write_attribute("name", name)
    index
  end

  def long_name
    "#{brand} #{name}"
  end

  def index
    self.tokens = MesCourses::Utils::Tokenizer.run(long_name).join(" ")
  end

  def self.search_string_is_valid?(search_string)
    MesCourses::Utils::Tokenizer.run(search_string) != []
  end

  def self.search_by_string_and_category(search_string, category)
    throw NotImplementedError.new("Item search not yet implemented") unless hierarchy_handles_item_search?(category)

    sql_clauses = []
    condition_params = {}
    MesCourses::Utils::Tokenizer.run(search_string).each_with_index do |token, i_token|
      param = "token#{i_token}"
      sql_clauses.push("items.tokens like :#{param}")
      condition_params[param.intern] = "%#{token}%"
    end
    condition_sql = sql_clauses.join(" and ")

    if !category.root?
      if category.children.empty?
        condition_sql = condition_sql + " and item_categories_items.item_category_id = :category_id"
        condition_params = condition_params.merge(:category_id => category.id)
      else
        condition_sql = condition_sql + " and item_categories_items.item_category_id in (:category_ids)"
        condition_params = condition_params.merge(:category_ids => category.children.map{ |c| c.id})
      end
    end

    Item.where(condition_sql, condition_params).joins("INNER JOIN item_categories_items ON (items.id = item_categories_items.item_id)")
  end

  private
  # At the moment, only 2 level category hierarchies can be searched through. Here we detect a hierarchy of 3 or more.
  def self.hierarchy_handles_item_search?(category)
    category.root? || category.children.empty? || category.parent.root?
  end

end
