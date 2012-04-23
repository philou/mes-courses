# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'tokenizer'

# An item for sale
class Item < ActiveRecord::Base
  has_and_belongs_to_many :dishes
  belongs_to :item_category

  validates_presence_of :name, :item_category, :price, :remote_id, :tokens
  validates_uniqueness_of :remote_id

  attr_protected :tokens

  after_initialize :index

  def name=(name)
    write_attribute("name", name)
    index
  end
  def summary=(summary)
    write_attribute("summary", summary)
    index
  end

  def index
    self.tokens = Tokenizer.run("#{name} #{summary}").join(" ")
  end

  def self.search_by_string_and_category(search_string, category)
    throw NotImplementedError.new("Item search not yet implemented") unless hierarchy_handles_item_search?(category)

    sql_clauses = []
    condition_params = {}
    Tokenizer.run(search_string).each_with_index do |token, i_token|
      param = "token#{i_token}"
      sql_clauses.push("tokens like :#{param}")
      condition_params[param.intern] = "%#{token}%"
    end
    condition_sql = sql_clauses.join(" and ")

    if !category.root?
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
    category.root? || category.children.empty? || category.parent.root?
  end

end
