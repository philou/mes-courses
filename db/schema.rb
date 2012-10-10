# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121010064221) do

  create_table "blog_comments", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.string   "website"
    t.text     "body",       :null => false
    t.integer  "post_id",    :null => false
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_comments", ["post_id"], :name => "index_blog_comments_on_post_id"

  create_table "blog_posts", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "body",                          :null => false
    t.integer  "blogger_id"
    t.string   "blogger_type"
    t.integer  "comments_count", :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "blog_posts", ["blogger_type", "blogger_id"], :name => "index_blog_posts_on_blogger_type_and_blogger_id"

  create_table "cart_lines", :force => true do |t|
    t.integer  "quantity",   :null => false
    t.integer  "item_id",    :null => false
    t.integer  "cart_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "cart_lines", ["cart_id", "item_id"], :name => "cart_lines_cart_id_item_id_index", :unique => true
  add_index "cart_lines", ["cart_id"], :name => "cart_lines_cart_id_index"

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.text     "queue"
  end

  create_table "dishes", :force => true do |t|
    t.text     "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "dishes", ["name"], :name => "dishes_name_index", :unique => true

  create_table "dishes_items", :id => false, :force => true do |t|
    t.integer "dish_id", :null => false
    t.integer "item_id", :null => false
  end

  add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id_index"
  add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id_index"

  create_table "import_sold_out_items", :primary_key => "item_id", :force => true do |t|
  end

  create_table "item_categories", :force => true do |t|
    t.text     "name",       :null => false
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id_index", :unique => true

  create_table "item_categories_items", :id => false, :force => true do |t|
    t.integer "item_id",          :null => false
    t.integer "item_category_id", :null => false
  end

  add_index "item_categories_items", ["item_category_id"], :name => "item_categories_items_item_category_id_index"
  add_index "item_categories_items", ["item_id"], :name => "item_categories_items_item_id_index"

  create_table "items", :force => true do |t|
    t.text     "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.decimal  "price"
    t.text     "image"
    t.text     "summary"
    t.integer  "remote_id"
    t.text     "tokens",     :null => false
  end

  add_index "items", ["remote_id"], :name => "items_remote_id_index", :unique => true

  create_table "model_stats", :force => true do |t|
    t.text     "name",       :null => false
    t.integer  "count",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "model_stats", ["name"], :name => "model_name_name_index", :unique => true

  create_table "orders", :force => true do |t|
    t.integer  "cart_id",                                              :null => false
    t.integer  "store_id",                                             :null => false
    t.string   "warning_notices_text",       :default => "",           :null => false
    t.text     "error_notice",               :default => "",           :null => false
    t.integer  "forwarded_cart_lines_count", :default => 0,            :null => false
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.text     "status",                     :default => "not_passed", :null => false
  end

  create_table "stores", :force => true do |t|
    t.text     "url",                           :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "expected_items", :default => 0, :null => false
    t.text     "sponsored_url",                 :null => false
  end

  add_index "stores", ["url"], :name => "stores_url_index", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.text     "email",              :default => "", :null => false
    t.text     "encrypted_password", :default => "", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "name",                               :null => false
  end

  add_index "users", ["email"], :name => "users_email_index", :unique => true
  add_index "users", ["name"], :name => "users_name_index", :unique => true

  create_table "visited_urls", :force => true do |t|
    t.text "url", :null => false
  end

  add_index "visited_urls", ["url"], :name => "visited_urls_url_index", :unique => true

  add_foreign_key "cart_lines", "carts", :name => "cart_lines_cart_id_fk"
  add_foreign_key "cart_lines", "items", :name => "cart_lines_item_id_fk"

  add_foreign_key "dishes_items", "dishes", :name => "dishes_items_dish_id_fk"
  add_foreign_key "dishes_items", "items", :name => "dishes_items_item_id_fk"

  add_foreign_key "item_categories", "item_categories", :name => "item_categories_parent_id_fk", :column => "parent_id"

  add_foreign_key "item_categories_items", "item_categories", :name => "item_categories_items_item_category_id_fk"
  add_foreign_key "item_categories_items", "items", :name => "item_categories_items_item_id_fk"

  add_foreign_key "orders", "carts", :name => "orders_cart_id_fk"
  add_foreign_key "orders", "stores", :name => "orders_store_id_fk"

end
