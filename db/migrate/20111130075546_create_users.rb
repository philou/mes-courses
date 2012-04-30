# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

class CreateUsers < ActiveRecord::Migration

  class User < ActiveRecord::Base
  end

  def self.up
    create_table :users do |t|
      ## Database authenticatable
      t.string   "email",                             :default => "", :null => false
      t.string   "encrypted_password", :limit => 128, :default => "", :null => false
      t.string   "password_salt",                     :default => "", :null => false

      t.timestamps
    end

    User.create(:email => 'philippe.bourgau@gmail.com', :encrypted_password => "959720a131da16c6a88b4e38da13427cd1ab731d", :password_salt => "gDuEpxJd9Q-T-aHgqj3z")
  end

  def self.down
    drop_table :users
  end
end
