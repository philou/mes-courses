# Copyright (C) 2010, 2011 by Philippe Bourgau

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # returns an https url (ignored localy, piggyback on heroku)
  def https_url_for(params = {})
    if on_heroku?
      url_for( {:protocol => 'https', :host => "#{heroku_app_name}.heroku.com"}.merge(params))
    else
      url_for(params)
    end
  end

  def on_heroku?
    !ENV['APP_NAME'].nil?
  end

  def heroku_app_name
    ENV['APP_NAME']
  end

  # path for a category, defaults to the main browser for a nil or new category
  def any_item_category_path(category = nil)
    return "/item_category" if category.nil? || category.id.nil?

    item_category_path(category)
  end
end
