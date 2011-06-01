# Copyright (C) 2010, 2011 by Philippe Bourgau

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include HerokuHelper

  # returns an https url (ignored localy, piggyback on heroku)
  def https_url_for(params = {})
    if on_heroku?
      url_for( {:protocol => 'https', :host => "#{app_name}.heroku.com"}.merge(params))
    else
      url_for(params)
    end
  end

  # path for a category, defaults to the main browser for a nil or new category
  def any_item_category_path(*args)
    root_category_path = "/item_category"

    return root_category_path if args.empty?

    category = args[0]
    return root_category_path if category.nil? || category.id.nil?

    item_category_path(*args)
  end
end
