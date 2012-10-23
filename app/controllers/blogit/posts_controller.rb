# Copyright (C) 2012 by Philippe Bourgau

require_dependency Blogit::Engine.root.join('app', 'controllers', 'blogit', 'posts_controller').to_s

module Blogit
  class PostsController
    before_filter :assign_body_id

    def assign_body_id
      self.body_id= BLOG_BODY_ID
    end
  end
end
