# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ItemCategory.create!(:name => Constants::ROOT_ITEM_CATEGORY_NAME)
ItemCategory.create!(:name => Constants::DISABLED_ITEM_CATEGORY_NAME)
