# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class RemoveRemoteStoreOrderUrlFromOrder < ActiveRecord::Migration
  def self.up
    remove_column :orders, :remote_store_order_url
  end

  def self.down
    add_column :orders, :remote_store_order_url, :string
  end
end
