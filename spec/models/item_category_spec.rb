# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require 'lib/mes_courses/rails_utils/singleton_builder_spec_macros'

describe ItemCategory do
  extend MesCourses::RailsUtils::SingletonBuilderSpecMacros

  it "should have items" do
    category = ItemCategory.new(:name => "Boeuf")
    category.items.should_not be_nil
  end

  has_singleton(:root, Constants::ROOT_ITEM_CATEGORY_NAME)
  has_singleton(:disabled, Constants::DISABLED_ITEM_CATEGORY_NAME)

end
