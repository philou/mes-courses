# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Note: this is the data equivalent of schema.rb. It can not be deduced from the database because it is
#       impossible to differentiate seed from live data. Data should be added to an existing db through
#       both this seeds.rb file and a migration.

ItemCategory.create!(:name => ItemCategory::ROOT_NAME)
