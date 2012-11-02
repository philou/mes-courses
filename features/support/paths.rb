# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the login page/
      '/users/sign_in'

    when /logout/
      '/users/sign_out'

    when /the cart page/
      '/cart_lines'

    when /the full dish catalog page/
      '/dishes'

    when /the dish creation page/
      '/dishes/new'

    when /the "([^"]*)" dish page/
      "/dishes/#{Dish.find_by_name($1).id}"

    when /the "([^"]*)" dish item categories page/
      "/dishes/#{Dish.find_by_name($1).id}/item_categories"

    when /the "([^"]*)" dish "([^"]*)" item category page/
      "/dishes/#{Dish.find_by_name($1).id}/item_categories/#{ItemCategory.find_by_name($2).id}"

    when /the item categories page/
      "/item_categories"

    when /the "([^"]*)" item category page/
      "/item_categories/#{ItemCategory.find_by_name_and_parent_id($1, ItemCategory.root.id).id}"

    when /the "([^"]*)" item sub category page/
      "/item_categories/#{ItemCategory.find_by_name($1).id}"

    when /the blog page/
      '/blog'

    when /the blog article "([^"]*)" page/
      post = Blogit::Post.find_by_title($1)
      "/blog/posts/#{post.id}-#{post.title.gsub(' ','-')}"

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
