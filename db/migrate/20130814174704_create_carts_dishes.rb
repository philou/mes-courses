# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

class CreateCartsDishes < ActiveRecord::Migration
  def up
    create_table :carts_dishes, {:id => false} do |t|
      t.integer :cart_id, null: false
      t.integer :dish_id, null: false
    end

    add_index "carts_dishes", ["cart_id"], name: "carts_dishes_cart_id_index"
    add_index "carts_dishes", ["dish_id"], name: "carts_dishes_dish_id_index"
  end

  def down
    remove_index "carts_dishes", name: "carts_dishes_cart_id_index"
    remove_index "carts_dishes", name: "carts_dishes_dish_id_index"

    drop_table :carts_dishes
  end
end
