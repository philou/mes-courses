# Copyright (C) 2011 by Philippe Bourgau

class ChangeOrderStatusTypeToString < ActiveRecord::Migration

  STATUSES = [Order::NOT_PASSED, Order::PASSING, Order::SUCCEEDED, Order::FAILED ]

  def self.up
    add_column :orders, :status_as_string, :string
    STATUSES.each_with_index do |as_string, as_int|
      execute "UPDATE orders set status_as_string = '#{as_string}' where status = #{as_int}"
    end
    change_column :orders, :status_as_string, :string, :null => false

    remove_column :orders, :status
    rename_column :orders, :status_as_string, :status
  end

  def self.down
    add_column :orders, :status_as_int, :integer
    STATUSES.each_with_index do |as_string, as_int|
      execute "UPDATE orders set status_as_int = #{as_int} where status = '#{as_string}'"
    end
    change_column :orders, :status_as_int, :integer, :null => false

    remove_column :orders, :status
    rename_column :orders, :status_as_int, :status
  end
end
