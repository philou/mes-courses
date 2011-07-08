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

ActiveRecord::Schema.define(:version => 20110707065146) do

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

  create_table "dishes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dishes", ["name"], :name => "dishes_name", :unique => true

  create_table "dishes_items", :id => false, :force => true do |t|
    t.integer "dish_id", :null => false
    t.integer "item_id", :null => false
  end

  add_index "dishes_items", ["dish_id"], :name => "dishes_items_dish_id"
  add_index "dishes_items", ["item_id"], :name => "dishes_items_item_id"

  create_table "item_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_categories", ["name", "parent_id"], :name => "item_sub_types_name_item_type_id", :unique => true

  create_table "items", :force => true do |t|
    t.string   "name",             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_category_id", :null => false
    t.decimal  "price",            :null => false
    t.string   "image"
    t.string   "summary"
    t.integer  "remote_id",        :null => false
  end

  add_index "items", ["remote_id"], :name => "items_remote_id_index", :unique => true

  create_table "model_stats", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "count",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "model_stats", ["name"], :name => "model_name_name_index", :unique => true

  create_table "stores", :force => true do |t|
    t.string   "url",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["url"], :name => "stores_url", :unique => true

  create_table "to_delete_items", :primary_key => "item_id", :force => true do |t|
  end

  create_table "visited_urls", :force => true do |t|
    t.string "url", :null => false
  end

  add_index "visited_urls", ["url"], :name => "visited_urls_url", :unique => true

end
