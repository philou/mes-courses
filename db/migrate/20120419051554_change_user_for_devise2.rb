# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class ChangeUserForDevise2 < ActiveRecord::Migration
  def up
    change_column :users, :encrypted_password, :string, :null => false, :default => ""
    change_column :users, :password_salt, :string

    add_index :users, :email,                :unique => true, :name => "users_email_index"
  end

  def down
    remove_index :users, :name => "users_email_index"

    change_column :users, :encrypted_password, :string, :limit => 128, :null => false, :default => ""
    change_column :users, :password_salt, :string, :null => false, :defaut => ""
  end
end
