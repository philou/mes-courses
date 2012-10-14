# This migration comes from blogit (originally 20110814093229)
class CreateBlogComments < ActiveRecord::Migration
  def change
    create_table :blog_comments do |t|
      t.text :name, null: false
      t.text :email, null: false
      t.text :website
      t.text :body, null: false
      t.references :post, null: false
      t.text :state

      t.timestamps
    end
    add_index :blog_comments, :post_id
  end
end
