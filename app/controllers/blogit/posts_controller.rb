# Copyright (C) 2012 by Philippe Bourgau

require_dependency Blogit::Engine.root.join('app', 'controllers', 'blogit', 'posts_controller').to_s

module Blogit
  class PostsController
    before_filter :assign_body_id, :compute_tag_frequencies
    layout 'blog'

    def assign_body_id
      self.body_id= BLOG_BODY_ID
    end

    def compute_tag_frequencies
      @tags = Post.tag_counts
    end
  end
end
