# Copyright (C) 2010, 2011 by Philippe Bourgau

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

# Reimports a store, waits for the next second
# records db metrics before reimporting
def reimport(store)

  [Item, ItemCategory].each do |record|
    record.collect_past_metrics
  end

  [Item, ItemCategory].each do |record|
    while record.past_metrics[:updated_at].sec == Time.now.sec
      sleep(0.01)
    end
  end

  store.import
end
