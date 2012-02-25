# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class AddRemoteIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :remote_id, :integer
  end

  def self.down
    remove_column :items, :remote_id
  end
end
