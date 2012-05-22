# -*- encoding: utf-8 -*-
# Copyright (C) 2011 by Philippe Bourgau

class AddDefaultValuesToOrders < ActiveRecord::Migration

  def self.up
    change_column :orders, :status, :string, :null => false, :default => Order::NOT_PASSED
    change_column :orders, :warning_notices_text, :string, :null => false, :default => ""
    change_column :orders, :error_notice, :string, :null => false, :default => ""
    change_column :orders, :forwarded_cart_lines_count, :integer, :null => false, :default => 0
  end

  def self.down
    change_column :orders, :status, :string, :null => false
    change_column :orders, :warning_notices_text, :string, :null => false
    change_column :orders, :error_notice, :string, :null => false
    change_column :orders, :forwarded_cart_lines_count, :integer, :null => false
  end
end
