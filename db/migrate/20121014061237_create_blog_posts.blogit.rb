# Copyright (C) 2014 by Philippe Bourgau


# This migration comes from blogit (originally 20110814091434)
class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.text :title, null: false
      t.text :body, null: false
      t.references :blogger, polymorphic: true
      t.integer :comments_count, default: 0, null: false
      t.timestamps
    end
    add_index :blog_posts, [:blogger_type, :blogger_id]
  end
end
