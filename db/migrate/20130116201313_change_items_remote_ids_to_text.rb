# Copyright (C) 2013 by Philippe Bourgau

class ChangeItemsRemoteIdsToText < ActiveRecord::Migration
  def up
    change_column :items, :remote_id, :text
  end

  def down
    change_column :items, :remote_id, :integer
  end
end
