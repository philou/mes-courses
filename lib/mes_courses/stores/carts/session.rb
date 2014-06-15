# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau
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


module MesCourses
  module Stores
    module Carts

      # A loged in session on the remote store. Manipulates the remote cart, and performs error checking.
      class Session
        include WithLogoutMixin

        def initialize(store_api)
          @store_api = store_api
        end

        # logs out from the store
        def logout
          @store_api.logout
        end

        # total value of the remote cart
        def cart_value
          @cart_value ||= @store_api.cart_value
        end

        # empties the cart of the current user
        def empty_the_cart
          @store_api.empty_the_cart
          @cart_value = 0.0
        end

        # adds items to the cart of the current user
        # Throws UnavailableItemError if the value of the cart did not change
        def add_to_cart(quantity, item)
          return if (quantity == 0)

          old_cart_value = cart_value
          @store_api.add_to_cart(quantity, item.remote_id)
          new_cart_value = @store_api.cart_value

          raise UnavailableItemError.new("Item '#{item.name}' is not available") unless new_cart_value != old_cart_value

          @cart_value = new_cart_value
        end

      end
    end
  end
end
