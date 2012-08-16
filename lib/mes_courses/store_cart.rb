# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module MesCourses::StoreCart
  autoload_relative_ex :Base, "base"
  autoload_relative_ex :Api, "api"
  autoload_relative_ex :AuchanDirectApi, "auchan_direct_api"
  autoload_relative_ex :DummyApi, "dummy_api"
  autoload_relative_ex :Session, "session"
  autoload_relative_ex :WithLogoutMixin, "with_logout_mixin"
  autoload_relative_ex :UnavailableItemError, "unavailable_item_error"
  autoload_relative_ex :InvalidAccountError, "invalid_account_error"
end
