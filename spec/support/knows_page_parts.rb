# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013, 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


module KnowsPageParts

  def notice
    Xpath::Specs::PagePart.new("a notice", "//div[@class='notice']")
  end

  def buying_confirmation_notice(name)
    notice.that("has text '#{text}", "/p[contains(text(),'#{name}') and contains(text(),'#{CartLinesController::BUYING_CONFIRMATION_NOTICE}')]")
  end

  def items_panel
    Xpath::Specs::PagePart.new("an items panel", "//div[@id='items-panel']")
  end

  def item_with_name(name)
    items_panel.with("an item named '#{name}'", "//tr[td[contains(.,'#{name}')]]")
  end

  def item_with_price(name, price)
    item_with_name(name).that("has a price of #{price}€", "/td[contains(.,'#{price}€')]")
  end

  def item_with_brand(name, brand)
    item_with_name(name).that("comes from #{brand}", "/td[contains(.,'#{brand}')]")
  end

  def item_with_image(name, image)
    item_with_name(name).that("has image #{image}", "/td/img[@src='#{image}']")
  end

  def disabled_item_with_name(name)
    item_with_name(name).that("is disabled", "[//img[@src='/images/disabled.png'] and //input[@type='submit' and @disabled='disabled' and contains(@class, 'disabled')]]")
  end

  def enabled_item_with_name(name)
    item_with_name(name).that("is enabled", "[//input[@type='submit' and not(@disabled)]]")
  end

  def dish_panel
    Xpath::Specs::PagePart.new("the dish panel", "//table[@id='dish-panel']")
  end

  def dish_line
    dish_panel.with("a dish", "//tr")
  end

  def dish_with_name(name)
    dish_line.that("is named #{name}", "[td[contains(.,'#{name}')]]")
  end

  def disabled_dish_with_name(name)
    dish_with_name(name).that("is disabled", "[//input[@type='submit' and @disabled='disabled' and contains(@class, 'disabled') and @value]]")
  end

  def enabled_dish_with_name(name)
    dish_with_name(name).that("is enabled", "[//input[@type='submit' and not(@disabled)]]")
  end

  def cart_line
    Xpath::Specs::PagePart.new("a cart line", "//tr[not(td/text()='Total')]")
  end

  def cart_line_with_long_name(long_name)
    cart_line.that("is named #{long_name}", "[td/text()='#{long_name}']")
  end

  def cart_line_with_long_name_and_quantity(long_name, quantity)
    cart_line_with_long_name(long_name).that("has quantity #{quantity}", "[td[contains(.,'#{quantity} x')]]")
  end
  def cart_line_with_long_name_and_price(long_name, price)
    cart_line_with_long_name(long_name).that("has price #{price}", "[td[contains(.,'#{price}€')]]")
  end

  def cart_total(amount)
    Xpath::Specs::PagePart.new("the cart total amount of #{amount}", "//tr[td/text()='Total'][td[contains(.,'#{amount}€')]]")
  end

  def blog_body
    Xpath::Specs::PagePart.new("a blog body", "//body[@id='blog']")
  end

  def blog_sidebar
    blog_body.with("a blog sidebar", "//div[@id='blog-sidebar']")
  end

  def blog_sidebar_section(id)
    blog_sidebar.with("a blog #{id} section", "/div[@id='#{id}' and @class='sidebar-section']")
  end

  def link_to_posts_with_tag(name)
    Xpath::Specs::PagePart.new("a link to blog posts with tag '#{name}'", "//a[@href='#{blog.tagged_blog_posts_path(name)}']")
  end

  def link_to_post(name)
    Xpath::Specs::PagePart.new("a link to blog post '#{name}'", "//a[text()='#{name}' and matches(@href,'/blog/posts/.*#{name})]")
  end

  def blog_post
    blog_body.with("a blog post", "//div[@id='blog-posts']")
  end

  def blog_post_social_bar
    blog_post.with("a social bar", "/div[@id='blog_share_bar']")
  end
  def blog_post_related_posts
    blog_post.with("a related posts section", "/div[@id='blog_related']")
  end
  def blog_post_disqus_comments
    blog_post.with("disqus comments", "/div[@id='disqus_thread']")
  end
end
