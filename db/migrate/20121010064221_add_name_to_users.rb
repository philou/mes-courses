# Copyright (C) 2012 by Philippe Bourgau

class AddNameToUsers < ActiveRecord::Migration

  INDEX_NAME = "users_name_index"

  def self.up
    add_column :users, :name, :text

    execute %{UPDATE users SET name = email}

    change_column :users, :name, :text, :null => false
    add_index :users, :name, name: INDEX_NAME, unique: true

    execute %{UPDATE users SET name = 'Philippe' WHERE name = 'philippe.bourgau@mes-courses.fr' }
  end

  def self.down
    remove_index :users, name: INDEX_NAME
    remove_column :users, :name
  end
end
