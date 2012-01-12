# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120112054438) do

  create_table "cart_lines", :force => true do |t|
    t.integer  "quantity",   :null => false
    t.integer  "item_id",    :null => false
    t.integer  "cart_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_lines", ["cart_id", "item_id"], :name => "cart_lines_cart_id_item_id_index", :unique => true
  add_index "cart_lines", ["cart_id"], :name => "cart_lines_cart_id_index"

  create_table "carts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dishes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dishes", ["name"], :name => "dishes_name_index", :unique => true

  create_table "dishes_items", :id => false, :force => true do |t|
    t.integer "dish_id", :null => false
    t.integer "item_id", :null => false
  end

  add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id_index"
  add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id_index"

  create_table "item_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id_index", :unique => true

  create_table "items", :force => true do |t|
    t.string   "name",             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_category_id", :null => false
    t.decimal  "price",            :null => false
    t.string   "image"
    t.string   "summary"
    t.integer  "remote_id",        :null => false
    t.string   "tokens",           :null => false
  end

  add_index "items", ["remote_id"], :name => "items_remote_id_index", :unique => true

  create_table "model_stats", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "count",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "model_stats", ["name"], :name => "model_name_name_index", :unique => true

  create_table "orders", :force => true do |t|
    t.integer  "cart_id",                    :null => false
    t.integer  "store_id",                   :null => false
    t.text     "warning_notices_text",       :null => false
    t.string   "error_notice",               :null => false
    t.integer  "forwarded_cart_lines_count", :null => false
    t.string   "remote_store_order_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                     :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "url",                           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expected_items", :default => 0, :null => false
  end

  add_index "stores", ["url"], :name => "stores_url_index", :unique => true

  create_table "to_delete_items", :primary_key => "item_id", :force => true do |t|
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :default => "", :null => false
    t.string   "encrypted_password", :limit => 128, :default => "", :null => false
    t.string   "password_salt",                     :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "visited_urls", :force => true do |t|
    t.string "url", :null => false
  end

  add_index "visited_urls", ["url"], :name => "visited_urls_url_index", :unique => true

  add_foreign_key "cart_lines", "carts", :name => "cart_lines_cart_id_fk"

  add_foreign_key "dishes_items", "dishes", :name => "dishes_items_dish_id_fk"
  add_foreign_key "dishes_items", "items", :name => "dishes_items_item_id_fk"

  add_foreign_key "item_categories", "item_categories", :name => "item_categories_parent_id_fk", :column => "parent_id"

  add_foreign_key "items", "item_categories", :name => "items_item_category_id_fk"

  add_foreign_key "orders", "carts", :name => "orders_cart_id_fk"
  add_foreign_key "orders", "stores", :name => "orders_store_id_fk"

end
