class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :cart_id, :null => false
      t.integer :store_id, :null => false
      t.text :missing_items_names, :null => false
      t.integer :forwarded_cart_lines_count, :null => false
      t.string :remote_store_order_url

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
