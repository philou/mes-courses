# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

module MesCourses::Stores::Carts

  describe DummyApi do
    it_should_behave_like "Any Api"

    before(:all) do
      @store_cart_api = DummyApi
    end
  end
end
