# Copyright (C) 2013 by Philippe Bourgau

require_relative "../constants"

# Logging through the affiliation url empties the cart !
class RemoveAuchanDirectAffiliation < ActiveRecord::Migration
  def up
    execute %{UPDATE stores SET sponsored_url = url WHERE url = '#{DB::Constants::AUCHAN_DIRECT_URL}'}
  end

  def down
    execute %{UPDATE stores SET sponsored_url = '#{DB::Constants::AUCHAN_DIRECT_AFFILINET_URL}' WHERE url = '#{DB::Constants::AUCHAN_DIRECT_URL}'}
  end
end
