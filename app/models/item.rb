# Copyright (C) 2010, 2011 by Philippe Bourgau

# An item for sale
class Item < ActiveRecord::Base
  has_and_belongs_to_many :dishes
  belongs_to :item_category

  validates_presence_of :name, :item_category, :price
  validates_uniqueness_of :name, :scope => "item_category_id"

  def self.search_by_keyword_and_category(keyword, category = nil)
    throw NotImplementedError.new("Item search not yet implemented") unless hierarchy_handles_item_search?(category)

    condition_sql = "(lower(name) like :keyword or lower(summary) like :keyword)"
    condition_params = {:keyword => "%#{keyword.downcase}%"}

    if category
      if category.children.empty?
        condition_sql = condition_sql + " and item_category_id = :category_id"
        condition_params = condition_params.merge(:category_id => category.id)
      else
        condition_sql = condition_sql + " and item_category_id in (:category_ids)"
        condition_params = condition_params.merge(:category_ids => category.children.map{ |c| c.id})
      end
    end

    Item.find(:all, :conditions => [condition_sql, condition_params])
  end

  private
  # At the moment, only 2 level category hierarchies can be searched through. Here we detect a hierarchy of 3 or more.
  def self.hierarchy_handles_item_search?(category)
    category.nil? || category.children.empty? || category.parent.nil?
  end

end
