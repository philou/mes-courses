# Copyright (C) 2013 by Philippe Bourgau

class ChangeItemsRemoteIdsToText < ActiveRecord::Migration
  def up
    change_column :items, :remote_id, :text
  end

  def down
    execute %{ALTER TABLE items ALTER remote_id TYPE integer USING remote_id::int}
  end
end
