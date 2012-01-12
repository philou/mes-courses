# Copyright (C) 2012 by Philippe Bourgau

# Decrease the expected items of auchandirect store to 6000 because 7000 was often too high
class DecreaseAuchanDirectExpectedItems < ActiveRecord::Migration
  def self.up
    execute "UPDATE stores SET expected_items = 6000 WHERE url = 'http://www.auchandirect.fr'"
  end

  def self.down
    execute "UPDATE stores SET expected_items = 7000 WHERE url = 'http://www.auchandirect.fr'"
  end
end
