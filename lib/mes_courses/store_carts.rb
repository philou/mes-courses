# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module MesCourses
  module StoreCarts
    autoload :Base, "mes_courses/store_carts/base"
    autoload :Api, "mes_courses/store_carts/api"
    autoload :AuchanDirectApi, "mes_courses/store_carts/auchan_direct_api"
    autoload :DummyApi, "mes_courses/store_carts/dummy_api"
    autoload :Session, "mes_courses/store_carts/session"
    autoload :WithLogoutMixin, "mes_courses/store_carts/with_logout_mixin"
    autoload :UnavailableItemError, "mes_courses/store_carts/unavailable_item_error"
    autoload :InvalidAccountError, "mes_courses/store_carts/invalid_account_error"
  end
end
