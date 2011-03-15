# Copyright (C) 2011 by Philippe Bourgau

class CreateCartLines < ActiveRecord::Migration
  def self.up
    create_table :cart_lines do |t|
      t.integer :quantity, :null => false
      t.integer :item_id, :null => false
      t.integer :cart_id, :null => false

      t.timestamps
   end

    add_index :cart_lines, [:cart_id], :name => "cart_lines_cart_id_index", :unique => false
    add_index :cart_lines, [:cart_id,:item_id], :name => "cart_lines_cart_id_item_id_index", :unique => true
  end

  def self.down
    remove_index :cart_lines, "cart_lines_cart_id_index"
    remove_index :cart_lines, "cart_lines_cart_id_item_id_index"

    drop_table :cart_lines
  end
end
