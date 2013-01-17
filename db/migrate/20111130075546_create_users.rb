# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

class CreateUsers < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  def self.up
    create_table :users do |t|
      ## Database authenticable
      t.string   "email",                             :default => "", :null => false
      t.string   "encrypted_password", :limit => 128, :default => "", :null => false
      t.string   "password_salt",                     :default => "", :null => false

      t.timestamps
    end

    boss = User.new
    boss.email = 'philippe.bourgau@gmail.com'
    boss.encrypted_password = "959720a131da16c6a88b4e38da13427cd1ab731d"
    boss.password_salt = "gDuEpxJd9Q-T-aHgqj3z"
    boss.save!
  end

  def self.down
    drop_table :users
  end
end
