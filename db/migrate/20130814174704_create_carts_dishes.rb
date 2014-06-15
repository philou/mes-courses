# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


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
