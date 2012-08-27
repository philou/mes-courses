# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include MesCourses::Utils::HerokuHelper

  def self.included(base)
    base.send :include, PathBarHelper
  end

  # path for a category, defaults to the main browser for a nil or new category
  def any_item_category_path(*args)
    root_category_path = item_categories_path

    return root_category_path if args.empty?

    category = args[0]
    return root_category_path if category.nil? || category.id.nil?

    item_category_path(*args)
  end

  def google_analytics_enabled?
    ENV["GOOGLE_ANALYTICS_ENABLED"] == true.to_s
  end
end
