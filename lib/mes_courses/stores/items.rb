# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module MesCourses::Stores::Items
  autoload_relative_ex :ApiBuilder, "api_builder"
  autoload_relative_ex :Api, "api"
  autoload_relative_ex :BrowsingError, "browsing_error"
  autoload_relative_ex :Digger, "digger"
  autoload_relative_ex :NullDigger, "null_digger"
  autoload_relative_ex :DummyApi, "dummy_api"
  autoload_relative_ex :RealDummyConstants, "real_dummy_constants"
  autoload_relative_ex :Walker, "walker"
  autoload_relative_ex :WalkerPage, "walker_page"
  autoload_relative_ex :WalkerPageError, "walker_page_error"
end
