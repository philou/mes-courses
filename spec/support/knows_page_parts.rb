# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module KnowsPageParts

  def items_panel
    PagePart.new("an items panel", "//div[@id='items-panel']")
  end

  def item_with_name(name)
    items_panel.with("an item named '#{name}'", "//tr[td[contains(.,'#{name}')]]")
  end

  def disabled_item_with_name(name)
    item_with_name(name).that("is disabled", "[//img[@src='/images/disabled.png'] and //input[@type='submit' and @disabled='disabled']]")
  end

  def enabled_item_with_name(name)
    item_with_name(name).that("is enabled", "[//input[@type='submit' and not(@disabled)]]")
  end

  def dish_with_name(name)
    PagePart.new("a dish named #{name}", "//table[@id='dish-panel']//tr[td[contains(.,'#{name}')]]")
  end

  def disabled_dish_with_name(name)
    dish_with_name(name).that("is disabled", "[//input[@type='submit' and @disabled='disabled' and @value]]")
  end

  def enabled_dish_with_name(name)
    dish_with_name(name).that("is enabled", "[//input[@type='submit' and not(@disabled)]]")
  end

  def blog_body
    PagePart.new("a blog body", "//body[@id='blog']")
  end

  def blog_sidebar
    blog_body.with("a blog sidebar", "//div[@id='blog-sidebar']")
  end

  def blog_sidebar_section(id)
    blog_sidebar.with("a blog #{id} section", "/div[@id='#{id}' and @class='sidebar-section']")
  end

  def link_to_posts_with_tag(name)
    PagePart.new("a link to blog posts with tag '#{name}'", "//a[@href='#{blog.tagged_blog_posts_path(name)}']")
  end

  def link_to_post(name)
    PagePart.new("a link to blog post '#{name}'", "//a[text()='#{name}' and matches(@href,'/blog/posts/.*#{name})]")
  end

  def blog_post
    blog_body.with("a blog post", "//div[@id='blog-posts']")
  end

  def blog_post_social_bar
    blog_post.with("a social bar", "/div[@id='blog_share_bar']")
  end
  def blog_post_related_posts
    blog_post.with("related posts", "/div[@id='related_posts']")
  end
  def blog_post_disqus_comments
    blog_post.with("disqus comments", "/div[@id='disqus_thread']")
  end
end
