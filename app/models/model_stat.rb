# Copyright (C) 2011 by Philippe Bourgau

# Stats about instances saved in the database
class ModelStat < ActiveRecord::Base

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

    ModelStat.find(:all).each do |model_stat|
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
