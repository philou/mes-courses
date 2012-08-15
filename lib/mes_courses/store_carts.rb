# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module MesCourses
  module StoreCarts
    autoload :StoreCart, "mes_courses/store_carts/store_cart"
    autoload :StoreCartAPI, "mes_courses/store_carts/store_cart_api"
    autoload :AuchanDirectStoreCartAPI, "mes_courses/store_carts/auchan_direct_store_cart_api"
    autoload :DummyStoreCartAPI, "mes_courses/store_carts/dummy_store_cart_api"
    autoload :StoreCartSession, "mes_courses/store_carts/store_cart_session"
    autoload :WithLogoutMixin, "mes_courses/store_carts/with_logout_mixin"
  end
end
