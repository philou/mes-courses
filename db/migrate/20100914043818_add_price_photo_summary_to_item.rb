class AddPricePhotoSummaryToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :price, :decimal
    add_column :items, :image, :string
    add_column :items, :summary, :string
  end

  def self.down
    remove_column :items, :summary
    remove_column :items, :image
    remove_column :items, :price
  end
end
