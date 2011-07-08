class AddRemoteIdIndexToItem < ActiveRecord::Migration
  def self.up
    remove_index "items", :name => "altered_items_name_item_sub_type_id"
    change_column "items", "remote_id", :integer, :null => false
    add_index "items", ["remote_id"], :name => "items_remote_id_index", :unique => true
  end

  def self.down
    remove_index "items", :name => "items_remote_id_index"
    change_column "items", "remote_id", :integer, :null => true
    add_index "items", ["name", "item_category_id"], :name => "altered_items_name_item_sub_type_id", :unique => true
  end
end
