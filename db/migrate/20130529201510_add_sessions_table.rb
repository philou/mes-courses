# Copyright (C) 2013 by Philippe Bourgau

class AddSessionsTable < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.text :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at
  end
end
