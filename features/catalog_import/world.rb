# Copyright (C) 2010, 2011 by Philippe Bourgau

# Imports the store using the tweaks
def import_with(store, tweaks)
  store.import(:importing_strategy => StoreImportingTestStrategy.new(tweaks))
end

# Imports the store using tweaks, if the import was already done,
# it just restores the database as after the import.
def lazy_import_with(store, tweaks)
  $import_clones ||= {}
  import_key = {:store => store.url, :tweaks => tweaks}

  if $import_clones.has_key?(import_key)
    clones = ActiveRecord::Base.deep_clones($import_clones[import_key])
    clones.each { |record| record.save }

  else
    import_with(store, tweaks)
    records = ItemCategory.find(:all) | Item.find(:all)
    $import_clones[import_key] = ActiveRecord::Base.deep_clones(records)
  end
end

# Add the capability to retreive and store db metrics in an active record model
class ActiveRecord::Base
  # Current db model metrics
  def self.current_metrics
    {
      :count => count,
      :updated_at => maximum(:updated_at),
      :created_at => maximum(:created_at),
      :all => find(:all)
    }
  end

  def self.past_metrics
    @past_metrics
  end

  # Fills metrics from the db, NOW!
  def self.collect_past_metrics
    @past_metrics = current_metrics
  end
end

# Reimports a store, again, does not use lazy import,
# records db metrics before reimporting
def reimport(store, tweaks, extra_tweaks = {})
  [Item, ItemCategory].each do |record|
    record.collect_past_metrics
  end
  import_with(store, tweaks.merge(extra_tweaks))
end
